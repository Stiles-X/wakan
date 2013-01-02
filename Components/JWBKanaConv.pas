unit JWBKanaConv;
{
Converts kana to romaji and back according to a set of rules.
}

interface
uses Classes, JWBStrings;

{
Romaji translation table.
For more info see wakan.cfg.
}
type
  TRomajiTranslationRule = record
   { Hiragana and katakana: FStrings. Hex is already upcased! Do not upcase. }
    hiragana: string;
    katakana: string;
    japanese: string;
    english: string;
    czech: string;
   //These pointers always point to somewhere.
   //If hiragana or katakana strings are nil, they're pointing to const strings of '000000000'
   //So there's no need to check for nil; they're also guaranteed to have at least two 4-chars available
   //(for real strings which are one 4-char in length, they have #00 as next 4-char's first symbol,
   // so it won't match to anything)
   {$IFNDEF UNICODE}
    hiragana_ptr: PAnsiChar;
    katakana_ptr: PAnsiChar;
   {$ELSE}
   //These point to two UNICODE chars (4 bytes)
    hiragana_ptr: PWideChar;
    katakana_ptr: PWideChar;
   {$ENDIF}
  end;
  PRomajiTranslationRule = ^TRomajiTranslationRule;

  TRomajiTranslationTable = class
  protected
    FList: array of TRomajiTranslationRule;
    FListUsed: integer;
    procedure Grow(ARequiredFreeLen: integer);
    function GetItemPtr(Index: integer): PRomajiTranslationRule;{$IFDEF INLINE} inline;{$ENDIF}
    function MakeNewItem: PRomajiTranslationRule;
    procedure SetupRule(r: PRomajiTranslationRule);
  public
    procedure Add(const r: TRomajiTranslationRule); overload;
    procedure Add(const AHiragana, AKatakana, AJapanese, AEnglish, ACzech: string); overload;
    procedure Add(const s: string); overload;{$IFDEF INLINE} inline;{$ENDIF}
    procedure Clear;
    property Count: integer read FListUsed;
    property Items[Index: integer]: PRomajiTranslationRule read GetItemPtr; default;
  end;

  TRomajiReplacementRule = record
    s_find: string;
    s_repl: string;
    romatype: integer; //0 means any
    pref: char; //Q, H, K, #00 means any
  end;
  PRomajiReplacementRule = ^TRomajiReplacementRule;

  TRomajiReplacementTable = class
  protected
    FList: array of TRomajiReplacementRule;
    FListUsed: integer;
    procedure Grow(ARequiredFreeLen: integer);
    function GetItemPtr(Index: integer): PRomajiReplacementRule;{$IFDEF INLINE} inline;{$ENDIF}
    function MakeNewItem: PRomajiReplacementRule;
  public
    procedure Add(const r: TRomajiReplacementRule); overload;
    procedure Add(const AFind, ARepl: string; ARomaType: integer; APref: char); overload;
    procedure Add(const s: string; const pref: char); overload;{$IFDEF INLINE} inline;{$ENDIF}
    procedure Clear;
    property Count: integer read FListUsed;
    property Items[Index: integer]: PRomajiReplacementRule read GetItemPtr; default;
  end;

  TRomajiTranslator = class
  protected
    FTrans: TRomajiTranslationTable;
    FReplKtr: TRomajiReplacementTable;
    FReplRtk: TRomajiReplacementTable;
    function SingleKanaToRomaji(var ps: PFChar; romatype: integer): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const filename: string);
    procedure LoadFromStrings(const sl: TStrings);
    function KanaToRomaji(const s:FString;romatype:integer):string;
    function RomajiToKana(const s:string;romatype:integer;clean:boolean):FString;
  end;

implementation
uses SysUtils;

{ TRomajiTranslationTable }

function TRomajiTranslationTable.GetItemPtr(Index: integer): PRomajiTranslationRule;
begin
  Result := @FList[Index]; //valid until next list growth
end;

function TRomajiTranslationTable.MakeNewItem: PRomajiTranslationRule;
begin
 //Thread unsafe
  Grow(1);
  Result := @FList[FListUsed];
  Inc(FListUsed);
end;

//Reserves enough memory to store at least ARequiredFreeLen additional items to list.
procedure TRomajiTranslationTable.Grow(ARequiredFreeLen: integer);
const MIN_GROW_LEN = 40;
begin
  if Length(FList)-FListUsed>=ARequiredFreeLen then exit; //already have the space
 //else we don't grow in less than a chunk
  if ARequiredFreeLen < MIN_GROW_LEN then
    ARequiredFreeLen := MIN_GROW_LEN;
  SetLength(FList, Length(FList)+ARequiredFreeLen);
end;

const
 {$IFDEF UNICODE}
  UNICODE_ZERO_CODE: string = #00#00;
 {$ELSE}
  UNICODE_ZERO_CODE: string = '00000000';
 {$ENDIF}

//Makes various safety checks and sets up optimization fields for a rule
procedure TRomajiTranslationTable.SetupRule(r: PRomajiTranslationRule);
begin
 {$IFNDEF UNICODE}
 //Make sure hiragana and katakana have at least one 4-char in length, or are disabled
  if Length(r.hiragana)<4 then SetLength(r.hiragana, 0);
  if Length(r.katakana)<4 then SetLength(r.katakana, 0);
 //Drop symbols till the nearest 4-char
  if Length(r.hiragana) mod 4 <> 0 then SetLength(r.hiragana, Length(r.hiragana) - Length(r.hiragana) mod 4);
  if Length(r.katakana) mod 4 <> 0 then SetLength(r.katakana, Length(r.katakana) - Length(r.katakana) mod 4);
 {$ENDIF}
 //Setup optimization pointers
  r.hiragana_ptr := pointer(r.hiragana);
  if r.hiragana_ptr=nil then r.hiragana_ptr := pointer(UNICODE_ZERO_CODE);
  r.katakana_ptr := pointer(r.katakana);
  if r.katakana_ptr=nil then r.katakana_ptr := pointer(UNICODE_ZERO_CODE);
end;

procedure TRomajiTranslationTable.Add(const r: TRomajiTranslationRule);
begin
  SetupRule(@r);
  MakeNewItem^ := r;
end;

//Hiragana and katakana must be in decoded format (unicode on UFCHAR builds)
procedure TRomajiTranslationTable.Add(const AHiragana, AKatakana, AJapanese, AEnglish, ACzech: string);
var r: PRomajiTranslationRule;
begin
  r := MakeNewItem;
  r.hiragana := AHiragana;
  r.katakana := AKatakana;
  r.japanese := AJapanese;
  r.english := AEnglish;
  r.czech := ACzech;
  SetupRule(r);
end;

//Parses romaji translation rule from string form into record
//See comments in wakan.cfg for format details.
function ParseRomajiTranslationRule(const s: string): TRomajiTranslationRule; {$IFDEF INLINE}inline;{$ENDIF}
var s_parts: TStringArray;
begin
  s_parts := SplitStr(s, 5);
 {$IFDEF UNICODE}
  Result.hiragana := HexToUnicode(s_parts[0]);
  Result.katakana := HexToUnicode(s_parts[1]);
 {$ELSE}
  Result.hiragana := Uppercase(s_parts[0]);
  Result.katakana := Uppercase(s_parts[1]);
 {$ENDIF}
  Result.japanese := s_parts[2];
  Result.english := s_parts[3];
  Result.czech := s_parts[4];
end;

procedure TRomajiTranslationTable.Add(const s: string);
begin
  Add(ParseRomajiTranslationRule(s));
end;

procedure TRomajiTranslationTable.Clear;
begin
  SetLength(FList, 0);
  FListUsed := 0;
end;


{ TRomajiReplacementTable }

function TRomajiReplacementTable.GetItemPtr(Index: integer): PRomajiReplacementRule;
begin
  Result := @FList[Index]; //valid until next list growth
end;

function TRomajiReplacementTable.MakeNewItem: PRomajiReplacementRule;
begin
 //Thread unsafe
  Grow(1);
  Result := @FList[FListUsed];
  Inc(FListUsed);
end;

//Reserves enough memory to store at least ARequiredFreeLen additional items to list.
procedure TRomajiReplacementTable.Grow(ARequiredFreeLen: integer);
const MIN_GROW_LEN = 40;
begin
  if Length(FList)-FListUsed>=ARequiredFreeLen then exit; //already have the space
 //else we don't grow in less than a chunk
  if ARequiredFreeLen < MIN_GROW_LEN then
    ARequiredFreeLen := MIN_GROW_LEN;
  SetLength(FList, Length(FList)+ARequiredFreeLen);
end;

procedure TRomajiReplacementTable.Add(const r: TRomajiReplacementRule);
begin
  MakeNewItem^ := r;
end;

//Hiragana and katakana must be in decoded format (unicode on UFCHAR builds)
procedure TRomajiReplacementTable.Add(const AFind, ARepl: string; ARomaType: integer; APref: char);
var r: PRomajiReplacementRule;
begin
  r := MakeNewItem;
  r.s_find := AFind;
  r.s_repl := ARepl;
  r.romatype := ARomaType;
  r.pref := APref;
end;

//Parses romaji translation rule from string form into record
//See comments in wakan.cfg for format details.
function ParseRomajiReplacementRule(const s: string): TRomajiReplacementRule; {$IFDEF INLINE}inline;{$ENDIF}
var s_parts: TStringArray;
begin
  s_parts := SplitStr(s, 3);
  Result.s_find := s_parts[0];
  Result.s_repl := s_parts[1];
  if s_parts[2]<>'' then
    Result.romatype := StrToInt(s_parts[2])
  else
    Result.romatype := 0; //any
  Result.pref := #00; //by default
end;

procedure TRomajiReplacementTable.Add(const s: string; const pref: char);
var r: TRomajiReplacementRule;
begin
  r := ParseRomajiReplacementRule(s);
  r.pref := pref;
  Add(r);
end;

procedure TRomajiReplacementTable.Clear;
begin
  SetLength(FList, 0);
  FListUsed := 0;
end;



{ TRomajiTranslator }

constructor TRomajiTranslator.Create;
begin
  inherited Create;
  FTrans := TRomajiTranslationTable.Create;
  FReplKtr := TRomajiReplacementTable.Create;
  FReplRtk := TRomajiReplacementTable.Create;
end;

destructor TRomajiTranslator.Destroy;
begin
  FreeAndNil(FReplRtk);
  FreeAndNil(FReplKtr);
  FreeAndNil(FTrans);
  inherited;
end;

procedure TRomajiTranslator.Clear;
begin
  FTrans.Clear;
  FReplKtr.Clear;
  FReplRtk.Clear;
end;

{
Loads data from file.
The file must contain [Table], [KanaToRomaji] and [RomajiToKana*] sections,
and it can contain other sections, they'll be ignored.
}

procedure TRomajiTranslator.LoadFromFile(const filename: string);
var sl: TStringList;
begin
  sl := TStringList.Create();
  try
    sl.LoadFromFile(filename);
    LoadFromStrings(sl);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TRomajiTranslator.LoadFromStrings(const sl: TStrings);
const //sections
  LS_NONE = 0;
  LS_TABLE = 1;
  LS_KANATOROMAJI = 2;
  LS_ROMAJITOKANA = 3;
var i: integer;
  ln: string;
  sect: integer;
  pref: char;
begin
  Clear;
  pref := #00;
  sect := LS_NONE;
  for i := 0 to sl.Count - 1 do begin
    ln := Trim(sl[i]);
    if (Length(ln)<=0) or (ln[1]='#') or (ln[1]=';') then
      continue;

    if ln='[Romaji]' then
      sect := LS_TABLE
    else
    if ln='[KanaToRomaji]' then begin
      sect := LS_KANATOROMAJI;
      pref := #00;
    end else
    if ln='[RomajiToKana]' then begin
      sect := LS_ROMAJITOKANA;
      pref := #00;
    end else
    if ln='[RomajiToKanaK]' then begin
      sect := LS_ROMAJITOKANA;
      pref := 'K';
    end else
    if ln='[RomajiToKanaQ]' then begin
      sect := LS_ROMAJITOKANA;
      pref := 'Q';
    end else
    if ln='[RomajiToKanaH]' then begin
      sect := LS_ROMAJITOKANA;
      pref := 'H';
    end else
    if (Length(ln)>=2) and (ln[1]='[') then
     //Some unknown section, skip it
      sect := LS_NONE
    else
    case sect of
      LS_TABLE: FTrans.Add(ln);
      LS_ROMAJITOKANA: FReplRtk.Add(ln, pref);
      LS_KANATOROMAJI: FReplKtr.Add(ln, pref);
    end;
  end;
end;

{
KanaToRomaji().
This function here is a major bottleneck when translating,
so we're going to try and implement it reallly fast.
}

//Try to compare strings as integers, without any string routines
{$DEFINE INTEGER_HELL}

{$IFDEF INTEGER_HELL}
//Returns a pointer to an integer p+#c counting from 0
//This is pretty fast when inlined, basically the same as typing that inplace, so use without fear.
//You can even put c==0 and the code will be almost eliminated at compilation time. Delphi is smart!
function IntgOff(p: pointer; c: integer): PInteger; inline;
begin
  Result := PInteger(integer(p)+c*4);
end;
{$ENDIF}

//ps must have at least one 4-char symbol in it
function TRomajiTranslator.SingleKanaToRomaji(var ps: PFChar; romatype: integer): string;
{$IFDEF UNICODE}{$POINTERMATH ON}{$ENDIF}
var i:integer;
  r: PRomajiTranslationRule;
 {$IFNDEF UNICODE}
  pe: PFChar;
 {$ENDIF}
begin
 {$IFDEF UNICODE}
  if ps^=UH_HYPHEN then begin
    Inc(ps);
 {$ELSE}
 {$IFDEF INTEGER_HELL}
  if pinteger(ps)^=pinteger(@UH_HYPHEN)^ then begin
 {$ELSE}
  if FcharCmp(ps, UH_HYPHEN, 1) then begin
 {$ENDIF}
    Inc(ps, 4);
 {$ENDIF}
    Result := '-';
    exit;
  end;

 {$IFDEF UNICODE}
  if ps^=UH_LOWLINE then begin
    Inc(ps);
 {$ELSE}
 {$IFDEF INTEGER_HELL}
  if pinteger(ps)^=pinteger(@UH_LOWLINE)^ then begin
 {$ELSE}
  if FcharCmp(ps, UH_LOWLINE, 1) then begin
 {$ENDIF}
    Inc(ps, 4);
 {$ENDIF}
    Result := '_';
    exit;
  end;

 //first try 2 FChars
 //but we have to test that we have at least that much
 {$IFDEF UNICODE}
  if (ps^<>#00) and ((ps+1)^<>#00) then begin
 {$ELSE}
  pe := ps;
  Inc(pe, 4); //first symbol must be there
  if EatOneFChar(pe) then begin
 {$ENDIF}
    for i := 0 to FTrans.Count - 1 do begin
      r := FTrans[i];
     {$IFDEF UNICODE}
     //Compare two characters at once (see note below)
      if (PInteger(ps)^=PInteger(r.hiragana_ptr)^)
      or (PInteger(ps)^=PInteger(r.katakana_ptr)^) then begin
     {
     //Safer and slower version:
      if ((ps^=r.hiragana_ptr^) and ((ps+1)^=(r.hiragana_ptr+1)^))
      or ((ps^=r.katakana_ptr^) and ((ps+1)^=(r.katakana_ptr+1)^)) then
     }
     {$ELSE}
     {$IFDEF INTEGER_HELL}
      {
      Note on integer comparison optimization:
      We're not checking if roma_t[i].hiragana has one or two 4-chars.
      It's okay. If it has one, then roma_t[i].hiragana[5]==#00, and it wouldn't match
      to any 4-char hex combination.
      It also won't AV because the memory's dword aligned and hiragana[5] is accessible already.
      }
      if ((pinteger(ps)^=pinteger(r.hiragana_ptr)^)
      and (IntgOff(ps, 1)^=IntgOff(r.hiragana_ptr, 1)^))
      or ((pinteger(ps)^=pinteger(r.katakana_ptr)^)
      and (IntgOff(ps,1)^=IntgOff(r.katakana_ptr, 1)^)) then begin
     {$ELSE}
      if FcharCmp(ps, r.hiragana_ptr, 2)
      or FcharCmp(ps, r.katakana_ptr, 2) then begin
     {$ENDIF}
     {$ENDIF}
        case romatype of
          2: Result := r.english;
          3: Result := r.czech;
        else
          Result := r.japanese;
        end;
       {$IFDEF UNICODE}
        Inc(ps, 2);
       {$ELSE}
        ps := pe;
       {$ENDIF}
        exit;
      end;
    end;
  end;

 //this time 1 FChar only
  for i := 0 to FTrans.Count - 1 do begin
    r := FTrans[i];
   {$IFDEF UNICODE}
    if (ps^=r.hiragana_ptr^) or (ps^=r.katakana_ptr^) then begin
   {$ELSE}
   {$IFDEF INTEGER_HELL}
    if (pinteger(ps)^=pinteger(r.hiragana_ptr)^)
    or (pinteger(ps)^=pinteger(r.katakana_ptr)^) then begin
   {$ELSE}
    if FcharCmp(ps, r.hiragana_ptr, 1)
    or FcharCmp(ps, r.katakana_ptr, 1) then begin
   {$ENDIF}
   {$ENDIF}
      case romatype of
        2: Result := r.english;
        3: Result := r.czech;
      else
        Result := r.japanese;
      end;
     {$IFDEF UNICODE}
      Inc(ps);
     {$ELSE}
      Inc(ps, 4);
     {$ENDIF}
      exit;
    end;
  end;

 //Latin symbol
 {$IFDEF UNICODE}
  if PWord(ps)^ and $FF00 = 0 then begin
    Result := ps^;
    Inc(ps);
 {$ELSE}
  if (ps^='0') and (PChar(integer(ps)+1)^='0') then begin
    Result := HexToUnicode(ps, 4);
    Inc(ps, 4);
 {$ENDIF}
    exit;
  end;

 {$IFDEF UNICODE}
  Inc(ps);
 {$ELSE}
  Inc(ps, 4);
 {$ENDIF}
  Result := '?';
{$IFDEF UNICODE}{$POINTERMATH OFF}{$ENDIF}
end;

function TRomajiTranslator.KanaToRomaji(const s:FString;romatype:integer):string;
var upcased_s: FString;
  fn:string;
  s2:string;
 {$IFDEF UNICODE}
  ps: PWideChar;
 {$ELSE}
  ps, pn: PAnsiChar;
 {$ENDIF}
  i: integer;
  r: PRomajiReplacementRule;
begin
  if Length(s)<=0 then begin
    Result := '';
    exit;
  end;
  upcased_s := Uppercase(s);
  s2 := '';
 {$IFDEF UNICODE}
  ps := PWideChar(upcased_s);
 {$ELSE}
  ps := PAnsiChar(upcased_s);
 {$ENDIF}

 { Translation }
 {$IFDEF UNICODE}
  while ps^<>#00 do begin
 {$ELSE}
  pn := ps;
  while EatOneFChar(pn) do begin
 {$ENDIF}
    fn := SingleKanaToRomaji(ps, romatype); //also eats one or two symbols
    if (fn='O') and (length(s2)>0) then fn:=upcase(s2[length(s2)]); ///WTF?!!
    s2:=s2+fn;
   {$IFNDEF UNICODE}
    pn := ps; //because ps might have advanced further
   {$ENDIF}
  end;

 { Replacements }
  for i := 0 to FReplKtr.Count - 1 do begin
    r := FReplKtr[i];
    if ((r.romatype=0) or (r.romatype=romatype)) then
      repl(s2, r.s_find, r.s_repl);
  end;

  if (length(s2)>0) and (s2[length(s2)]='''') then delete(s2,length(s2),1);
  result:=s2;
end;

{
Also accepts strange first letter flags:
  Q
  K
  H
}
function TRomajiTranslator.RomajiToKana(const s:string;romatype:integer;clean:boolean):string;
var sr,s2,s3,fn:string;
  kata:integer;
  l,i:integer;
  pref: char;
  r: PRomajiReplacementRule;
begin
  if length(s)<=0 then begin
    Result := '';
    exit;
  end;

 { First character sometimes codes something (sometimes doesn't...) -- see replacements }
  pref := s[1];
  s2 := s;

 { Replacements }
  for i := 0 to FReplRtk.Count - 1 do begin
    r := FReplRtk[i];
    if ((r.romatype=0) or (r.romatype=romatype))
    and ((r.pref=#00) or (r.pref=pref)) then
   { Only a limited set of first letters are prefixes, so we shouldn't just compare pref to whatever --
    -- but since we only load those supported prefixes into r.pref and there's no way to break that,
     this will do. }
      repl(s2, r.s_find, r.s_repl);
  end;

 { Translation }
  kata:=0;
  s3:='';
  while length(s2)>0 do
  begin
    fn:='';
    if s2[1]='_'then fn:=fstr('_');
    if s2[1]='-'then fn:=fstr('-');
    for i:=0 to FTrans.Count-1 do
    begin
      case romatype of
        2: sr := FTrans[i].english;
        3: sr := FTrans[i].czech;
      else
        sr := FTrans[i].japanese;
      end;
      if pos(sr,s2)=1 then
      begin
        l:=length(sr);
        if kata=0 then
          fn := FTrans[i].hiragana
        else
          fn := FTrans[i].katakana;
        break;
      end else
      if (romatype>0) and (pos(FTrans[i].english,s2)=1) then
      begin
        l:=length(FTrans[i].japanese);
        if kata=0 then
          fn := FTrans[i].hiragana
        else
          fn := FTrans[i].katakana;
        break;
      end;
    end;

   //If we haven't found the match, try other romaji types
    if fn='' then
    for i:=0 to FTrans.Count-1 do
      if pos(FTrans[i].japanese,s2)=1 then
      begin
        l:=length(FTrans[i].japanese);
        if kata=0 then
          fn := FTrans[i].hiragana
        else
          fn := FTrans[i].katakana;
        break;
      end else
      if pos(FTrans[i].english,s2)=1 then
      begin
        l:=length(FTrans[i].english);
        if kata=0 then
          fn := FTrans[i].hiragana
        else
          fn := FTrans[i].katakana;
        break;
      end else
      if pos(FTrans[i].czech,s2)=1 then
      begin
        l:=length(FTrans[i].czech);
        if kata=0 then
          fn := FTrans[i].hiragana
        else
          fn := FTrans[i].katakana;
        break;
      end;

    if fn='' then
    begin
      if not clean then
        if s2[1]<>'''' then
         //Latin letter (supposedly)
         {$IFDEF UNICODE}
          fn := s2[1]
         {$ELSE}
          fn:=Format('00%2.2X',[ord(s2[1])])
         {$ENDIF}
        else
          fn:='';
      l:=1;
    end;
    if s2[1]='H'then
    begin
      kata:=0;
      l:=1;
      fn:='';
    end;
    if (s2[1]='K') or (s2[1]='Q') then
    begin
      kata:=1;
      l:=1;
      fn:='';
    end;
    delete(s2,1,l);
    s3:=s3+fn;
  end;
  result:=s3;
end;

end.
