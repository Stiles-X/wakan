﻿unit JWBWakanTextTests;

interface
uses TestFramework, JWBWakanText;

type
  TSourcePosTestCase = class(TTestCase)
  published
    procedure Initializers;
    procedure Arithmetics;
  end;

  TSourceBlockTestCase = class(TTestCase)
  published
    procedure Initializers;
    procedure Arithmetics;
  end;

 { Base class for cases which test TWakanText }
  TWakanTextTestCase = class(TTestCase)
  protected
    text: TWakanText;
    procedure SetUp; override;
    procedure TearDown; override;
   //Helpers
    function CompareFiles(const AFilename1, AFilename2: string): boolean;
    procedure CompareData(const AText: TWakanText);
  end;

 { Manipulations with TWakanText contents: accessing characters, lines }
  TLinesTestCase = class(TWakanTextTestCase)
  published
    procedure BaseState;
    procedure Clearing;
    procedure AddingLines;
    procedure SplittingLines;
    procedure DeletingCharacters;
    procedure DeletingLines;
    procedure DeletingBlocks;
    procedure LotsOfLines;
    procedure MiscSimple;
  end;

 { Wakan supports reading and writing text in a range of encodings, with or
  without BOM. }
  TEncodingTestCase = class(TWakanTextTestCase)
  protected
    function GetTestFilename(const AFilename: string): string;
    procedure LoadFile(const AFilename: string; AEncoding: byte);
    procedure VerifyText(const AFilename: string; AEncoding: byte);
    procedure VerifyAscii(const AFilename: string; AEncoding: byte);
    procedure VerifyAcp(const AFilename: string; AEncoding: byte);
    procedure LoadSaveCompare(const AFilename: string; AEncoding: byte;
      ABom: boolean; const ATestComment: string = '');
  published
    procedure Ascii;
    procedure UTF8;
    procedure UTF8Sign;
    procedure UTF16LE;
    procedure UTF16LESign;
    procedure UTF16BE;
    procedure UTF16BESign;
    procedure EUC;
    procedure ShiftJis;
    procedure Acp;

    procedure GuessAscii;
    procedure GuessUTF8;
    procedure GuessUTF8Sign;
    procedure GuessUTF16LE;
    procedure GuessUTF16LESign;
    procedure GuessUTF16BE;
    procedure GuessUTF16BESign;
    procedure GuessEUC;
    procedure GuessShiftJis;

    procedure SaveAscii;
    procedure SaveUTF8;
    procedure SaveUTF8Sign;
    procedure SaveUTF16LE;
    procedure SaveUTF16LESign;
    procedure SaveUTF16BE;
    procedure SaveUTF16BESign;
    procedure SaveEUC;
    procedure SaveShiftJis;
    procedure SaveAcp;
  end;

 { Wakan supports loading and saving from text (enhanced with ruby) and native
  WTT format which may contain dictionary references.
  This requires text encoder to be working -- run TEncodingTestCase first }
  TRubyTextTestCase = class(TWakanTextTestCase)
  protected
    function GetTestFilename(const AFilename: string): string;
    procedure SaveCompare(const AFilename: string; AAnnotMode: TTextAnnotMode;
      const ATestComment: string = '');
    procedure SaveReloadCompareDataWtt();
    procedure CheckNoRuby;
    procedure CheckRuby;
  published
    procedure TextNoRuby;
    procedure TextRuby;
    procedure WttSaveReload;
    procedure WttRuby;
    procedure WttDict;
    procedure WttOlderVersions;
  end;

 { Wakan can export in a wide range of formats, but most of those cannot be
  read back.
  To test a format we load the source, export it and compare the result. This
  relies on ruby parser working -- run TLoadSaveTestCase first }
  TExportTestCase = class(TWakanTextTestCase)
  protected
    function GetTestFilename(const AFilename: string): string;
    procedure LoadSave(const AFilename: string; AFormat: TTextSaveFormat;
      const ATestComment: string = '');
    procedure LoadSaveCompare(const AFilename: string; AFormat: TTextSaveFormat;
      const ATestComment: string = '');
  published
    procedure KanaOnly;
    procedure KanaOnlySpaces;
    procedure KanjiOnly;
    procedure KanjiKana;
    procedure Html;
    procedure HtmlFragm;
    procedure OpenDocumentContent;
    procedure OpenDocument;
  end;

  TPasteTestCase = class(TWakanTextTestCase)
  protected
    function GetTestFilename(const AFilename: string): string;
    procedure PasteAndTest(text2: TWakanText; ins: TSourcePos);
  published
    procedure PasteWtt;
    procedure PasteText;
  end;

 //TODO: Write PasteText()

implementation
uses SysUtils, Classes, JWBStrings, JWBConvert, StreamUtils;

procedure TSourcePosTestCase.Initializers;
var p1: TSourcePos;
begin
  p1 := SourcePos(3,4);
  Check(p1.x=3);
  Check(p1.y=4);
end;

procedure TSourcePosTestCase.Arithmetics;
var p1, p2: TSourcePos;
begin
 //Equal
  p1 := SourcePos(4,3);
  p2 := SourcePos(4,3);
  Check(p1=p2,'Arithmetics 1-1');
  Check(not(p1>p2),'Arithmetics 1-2');
  Check(not(p1<p2),'Arithmetics 1-3');
  Check(not(p2>p1),'Arithmetics 1-4');
  Check(not(p2<p1),'Arithmetics 1-5');
  Check(not(p2<>p1),'Arithmetics 1-6');

 //Difference in x
  p1 := SourcePos(5,3);
  p2 := SourcePos(6,3);
  Check(not(p1=p2),'Arithmetics 2-1');
  Check(not(p1>p2),'Arithmetics 2-2');
  Check(p1<p2,'Arithmetics 2-3');
  Check(p2>p1,'Arithmetics 2-4');
  Check(not(p2<p1),'Arithmetics 2-5');
  Check(p2<>p1,'Arithmetics 2-6');

 //Difference in y
  p1 := SourcePos(5,3);
  p2 := SourcePos(5,4);
  Check(not(p1=p2),'Arithmetics 3-1');
  Check(not(p1>p2),'Arithmetics 3-2');
  Check(p1<p2,'Arithmetics 3-3');
  Check(p2>p1,'Arithmetics 3-4');
  Check(not(p2<p1),'Arithmetics 3-5');
  Check(p2<>p1,'Arithmetics 3-6');

 //Difference in both
  p1 := SourcePos(5,3);
  p2 := SourcePos(6,4);
  Check(not(p1=p2),'Arithmetics 4-1');
  Check(not(p1>p2),'Arithmetics 4-2');
  Check(p1<p2,'Arithmetics 4-3');
  Check(p2>p1,'Arithmetics 4-4');
  Check(not(p2<p1),'Arithmetics 4-5');
  Check(p2<>p1,'Arithmetics 4-6');

 //y smaller but x bigger (position priority check)
  p1 := SourcePos(4,4);
  p2 := SourcePos(5,3);
  Check(not(p1=p2),'Arithmetics 5-1');
  Check(p1>p2,'Arithmetics 5-2');
  Check(not(p1<p2),'Arithmetics 5-3');
  Check(not(p2>p1),'Arithmetics 5-4');
  Check(p2<p1,'Arithmetics 5-5');
  Check(p2<>p1,'Arithmetics 5-6');
end;

procedure TSourceBlockTestCase.Initializers;
var b1: TSourceBlock;
begin
  b1 := SourceBlock(3,4,5,6);
  Check(b1.fromy=3);
  Check(b1.fromx=4);
  Check(b1.toy=5);
  Check(b1.tox=6);
end;

procedure TSourceBlockTestCase.Arithmetics;
var b1, b2, b: TSourceBlock;
begin
 //Equal
  b1 := SourceBlock(3,4,5,6);
  b2 := SourceBlock(3,4,5,6);
  Check(b1=b2);
  Check(not(b1<>b2));

 //Difference in one point
  b1 := SourceBlock(3,4,5,6);
  b2 := SourceBlock(4,4,5,6);
  Check(not(b1=b2));
  Check(b1<>b2);

  b1 := SourceBlock(3,4,5,6);
  b2 := SourceBlock(3,5,5,6);
  Check(not(b1=b2));
  Check(b1<>b2);

  b1 := SourceBlock(3,4,5,6);
  b2 := SourceBlock(3,4,6,6);
  Check(not(b1=b2));
  Check(b1<>b2);

  b1 := SourceBlock(3,4,5,6);
  b2 := SourceBlock(3,4,5,7);
  Check(not(b1=b2));
  Check(b1<>b2);

 //Valid intersection by y
  b1 := SourceBlock(1,1,10,1);
  b2 := SourceBlock(8,1,12,1);
  b := b2 and b1;
  Check(b.fromy=8);
  Check(b.fromx=1);
  Check(b.toy=10);
  Check(b.tox=1);
  b := b1 and b2;
  Check(b.fromy=8);
  Check(b.fromx=1);
  Check(b.toy=10);
  Check(b.tox=1);

 //Valid intersection by x only
  b1 := SourceBlock(4,5,10,6);
  b2 := SourceBlock(4,6,10,5);
  b := b2 and b1;
  Check(b.fromy=4);
  Check(b.fromx=6);
  Check(b.toy=10);
  Check(b.tox=5);
  b := b1 and b2;
  Check(b.fromy=4);
  Check(b.fromx=6);
  Check(b.toy=10);
  Check(b.tox=5);

 //No intersection
  b1 := SourceBlock(4,1,6,1);
  b2 := SourceBlock(8,1,10,1);
  b := b1 and b2;
 //We don't specifically define the values, but the block must be empty
  Check((b.fromy>b.toy)or((b.fromy=b.toy)and(b.fromx>b.tox)));
end;

procedure TWakanTextTestCase.SetUp;
begin
  text := TWakanText.Create;
end;

procedure TWakanTextTestCase.TearDown;
begin
  FreeAndNil(text);
end;

{ Binary comparison for files }
function TWakanTextTestCase.CompareFiles(const AFilename1, AFilename2: string): boolean;
var f1, f2: TStream;
  b1, b2: byte;
  r1, r2: boolean;
begin
  f1 := nil;
  f2 := nil;
  try
    f1 := TStreamReader.Create(
      TFileStream.Create(AFilename1, fmOpenRead),
      true
    );
    f2 := TStreamReader.Create(
      TFileStream.Create(AFilename2, fmOpenRead),
      true
    );

   { Can be easily made somewhat faster by reading in dwords and comparing
    only the number of bytes read (e.g. case 1: 2: 3: 4: if (d1 & $000F) == etc.) }
    Result := true;
    while true do begin
      r1 := (f1.Read(b1,1)=1);
      r2 := (f2.Read(b2,1)=1);
      if r1 xor r2 then
        Result := false;
      if b1<>b2 then
        Result := false;
      if (not r1) or (not Result) then //not Result => diff; not r1 => both over
        break;
    end;

  finally
    FreeAndNil(f2);
    FreeAndNil(f1);
  end;
end;

{ Compares another TWakanText to this one. Tests that the actual contents is
 the same, even if the order is different where it doesn't matter, etc. }
procedure TWakanTextTestCase.CompareData(const AText: TWakanText);
var i, j: integer;
  line1, line2: PCharacterLineProps;
  locdics: array of integer; //map: AText.docdics -> text.docdics
begin
  Check(text.Lines.Count=AText.Lines.Count, 'Number of lines differ');
  Check(text.PropertyLines.Count=AText.PropertyLines.Count, 'Number of property lines differ');

 //Dictionary lists (mb in different order)
  Check(text.docdic.Count=AText.docdic.Count, 'Number of dictionaries differ');
  SetLength(locdics, text.docdic.Count);
  for i := 0 to AText.docdic.Count-1 do begin
    j := text.docdic.IndexOf(AText.docdic[i]);
    Check(j>=0, 'Dictionary list differs');
    locdics[i] := j;
  end;

  for i := 0 to text.Lines.Count-1 do
    Check(text.Lines[i]=AText.Lines[i], 'Text contents differs');

  for i := 0 to text.PropertyLines.Count-1 do begin
    line1 := text.PropertyLines[i];
    line2 := AText.PropertyLines[i];
    Check(line1.charcount=line2.charcount, 'Property line length differs');
    for j := 0 to line1.charcount-1 do begin
      Check(line1.chars[j].wordstate=line2.chars[j].wordstate, 'Char wordstate differs');
      Check(line1.chars[j].learnstate=line2.chars[j].learnstate, 'Char learnstate differs');
      Check(line1.chars[j].dicidx=line2.chars[j].dicidx, 'Char dicidx differs');
      if line1.chars[j].dicidx<>0 then { else there's no link and docdic can be anything
        and we shouldn't check because Length(locdics) can be == 0 }
        Check(line1.chars[j].docdic=locdics[line2.chars[j].docdic], 'Char docdic differs');
      Check(line1.chars[j].rubyTextBreak=line2.chars[j].rubyTextBreak, 'Char rubyTextBreak differs');
      Check(line1.chars[j].ruby=line2.chars[j].ruby, 'Char ruby differs');
      Check(line1.chars[j].flags=line2.chars[j].flags, 'Char flags differ');
    end;
  end;
end;

procedure TLinesTestCase.BaseState;
begin
  Check(text.Lines<>nil);
  Check(text.PropertyLines<>nil);
  Check(text.Lines.Count=0);
  Check(text.PropertyLines.Count=0);
end;

procedure TLinesTestCase.Clearing;
begin
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Third line.');
  Check(text.Lines.Count=3);
  Check(text.PropertyLines.Count=3);

  text.Clear;
  Check(text.Lines<>nil);
  Check(text.PropertyLines<>nil);
  Check(text.Lines.Count=0);
  Check(text.PropertyLines.Count=0);

 //Again
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.Clear;
  Check(text.Lines.Count=0);
  Check(text.PropertyLines.Count=0);

 //Multiple times
  text.Clear;
  text.Clear;
  text.Clear;
  text.Clear;
  Check(text.Lines.Count=0);
  Check(text.PropertyLines.Count=0);
end;

procedure TLinesTestCase.AddingLines;
begin
 //Adding
  text.AddLine('Example text.');
  Check(text.Lines.Count=1);
  Check(text.PropertyLines.Count=1);
  Check(text.Lines[0]='Example text.');
  Check(text.PropertyLines[0].charcount=Length(text.Lines[0]));

  text.AddLine('Another line.');
  Check(text.Lines.Count=2);
  Check(text.PropertyLines.Count=2);
  Check(text.Lines[0]='Example text.');
  Check(text.PropertyLines[0].charcount=Length(text.Lines[0]));
  Check(text.Lines[1]='Another line.');
  Check(text.PropertyLines[1].charcount=Length(text.Lines[1]));
end;

procedure TLinesTestCase.SplittingLines;
begin
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Third line.');
  Check(text.Lines.Count=3, 'Initial line count is wrong.');

 //Splitting
  text.SplitLine(3,1); //2-nd line at 3-rd char
  Check(text.Lines.Count=4, 'Line count after splitting is wrong.');
  Check(text.PropertyLines.Count=4, 'Property line count after splitting is wrong.');
  Check(text.Lines[1]='Ano', 'First part of the line invalid after split: "'+text.Lines[1]+'"');
  Check(text.PropertyLines[1].charcount=Length(text.Lines[1]));
  Check(text.Lines[2]='ther line.', 'Second part of the line invalid after split: "'+text.Lines[2]+'"');
  Check(text.PropertyLines[2].charcount=Length(text.Lines[2]));
  Check(text.Lines[3]='Third line.');
  Check(text.PropertyLines[3].charcount=Length(text.Lines[3]));

  text.SplitLine(Length(text.Lines[3]), 3);
  Check(text.Lines.Count=5, 'Line count after splitting is wrong.');
  Check(text.Lines[4]='');

 //Joining
  text.JoinLine(3);
  Check(text.Lines.Count=4, 'Line count after joining is wrong.');
  Check(text.Lines[3]='Third line.');

  text.JoinLine(2);
  Check(text.Lines.Count=3);
  Check(text.Lines[2]='ther line.Third line.');
  Check(text.PropertyLines[2].charcount=Length(text.Lines[2]));

 //Splitting again
  text.SplitLine(0,0);
  Check(text.Lines.Count=4);
  Check(text.Lines[0]='');
  text.JoinLine(0);
  Check(text.Lines.Count=3);
  Check(text.Lines[0]='Example text.');
end;

procedure TLinesTestCase.DeletingCharacters;
begin
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Third line.');

  text.DeleteCharacter(1,0);
  Check(text.Lines[0]='Eample text.');
  Check(text.PropertyLines[0].charcount=Length(text.Lines[0]));
  text.DeleteCharacter(1,0);
  text.DeleteCharacter(1,0);
  Check(text.Lines[0]='Eple text.');
  text.DeleteCharacter(Length(text.Lines[0])-1,0);
  Check(text.Lines[0]='Eple text');
  text.DeleteCharacter(Length(text.Lines[0])-1,0);
  Check(text.Lines[0]='Eple tex');
  Check(text.PropertyLines[0].charcount=Length(text.Lines[0]));
  text.DeleteCharacter(0,0);
  Check(text.Lines[0]='ple tex');
  Check(text.PropertyLines[0].charcount=Length(text.Lines[0]));

 //Second line + SourcePos version
  text.DeleteCharacter(SourcePos(4,1));
  Check(text.Lines[1]='Anoter line.');
  text.DeleteCharacter(SourcePos(5,1));
  Check(text.Lines[1]='Anote line.');
  Check(text.PropertyLines[0].charcount=Length(text.Lines[0]));

 //Haven't we accidentally changed number of lines?
  Check(text.Lines.Count=3);
  Check(text.PropertyLines.Count=3);
end;

procedure TLinesTestCase.DeletingLines;
begin
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Third line.');
  text.AddLine('Fourth line.');
  text.AddLine('Fifth line.');

  text.DeleteLine(4);
  text.DeleteLine(0);
  text.DeleteLine(1);
  Check(text.Lines.Count=2, 'Line count wrong after deleting');
  Check(text.PropertyLines.Count=2);
  Check(text.Lines[0]='Another line.');
  Check(text.Lines[1]='Fourth line.');
end;

procedure TLinesTestCase.DeletingBlocks;
begin
 //Multiline block
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Third line.');
  text.DeleteBlock(SourceBlock(0,4,2,6));
  Check(text.Lines.Count=1);
  Check(text.PropertyLines.Count=1);
  Check(text.Lines[0]='Examline.', 'Multiline block');

 //Effectively empty block
  text.DeleteBlock(SourceBlock(0,3,0,2));
  text.DeleteBlock(SourceBlock(0,3,0,3));
  Check(text.Lines[0]='Examline.', 'Effectively empty block');

 //Block referencing a single invalid line
 //Single line is often a special case so have to check with invalid index here too
  text.DeleteBlock(SourceBlock(-100,2,-100,4));
  Check(text.Lines[0]='Examline.', 'Block referencing invalid line');

 //Single char
  text.DeleteBlock(SourceBlock(0,3,0,4));
  Check(text.Lines[0]='Exaline.', 'Single char');

 //Last char + lots more
  text.DeleteBlock(SourceBlock(0,Length(text.Lines[0])-1,0,Length(text.Lines[0])+100));
  Check(text.Lines[0]='Exaline', 'Last char + more');

 //Before first char + first char
  text.DeleteBlock(SourceBlock(-10,-1000,0,1));
  Check(text.Lines.Count=1);
  Check(text.PropertyLines.Count=1);
  Check(text.Lines[0]='xaline', 'Before first char + first char');

 //Everything that remains, but the line should be kept
  text.DeleteBlock(SourceBlock(0,-1000,0,+1000));
  Check(text.Lines.Count=1);
  Check(text.PropertyLines.Count=1);
  Check(text.Lines[0]='', 'Everything but keep the line');

 //Everything that remains AND the line (as being strictly inside the block)
  text.DeleteBlock(SourceBlock(-1,-1000,+1,+1000));
  Check(text.Lines.Count=0);
  Check(text.PropertyLines.Count=0);
end;

procedure TLinesTestCase.LotsOfLines;
var i: integer;
begin
  for i := 0 to 8000 do
    text.AddLine('Line '+IntToStr(i));
  Check(text.Lines.Count=8001);
  Check(text.PropertyLines.Count=8001);
  Check(text.Lines[655]='Line 655');

 //Deleting
  text.DeleteLine(0);
  text.DeleteLine(0);
  text.DeleteLine(0);
  text.DeleteLine(text.Lines.Count-1);
  text.DeleteLine(text.Lines.Count-1);
  text.DeleteLine(text.Lines.Count-1);
  Check(text.Lines.Count=8001-6);
  Check(text.Lines[0]='Line 3');
  Check(text.Lines[8000-6]='Line 7997');

  randomize();
  for i := text.Lines.Count-2 downto 0 do
    text.DeleteLine(random(text.Lines.Count));
  Check(text.Lines.Count=1);
  Check(text.PropertyLines.Count=1);
end;

procedure TLinesTestCase.MiscSimple;
begin
  text.AddLine('Example text.');
  text.AddLine('Another line.');
  text.AddLine('Third line.');

 //GetDoc
  Check(text.GetDoc(0,0)='E');
  Check(text.GetDoc(1,0)='x');
  Check(text.GetDoc(1000,0)=UH_ZERO);
  Check(text.GetDoc(0,1)='A');
  Check(text.GetDoc(2,1)='o');
  Check(text.GetDoc(1,2)='h');

 //GetDocChain
  text.PropertyLines[0].chars[1].wordstate := '<';
  text.PropertyLines[0].chars[2].wordstate := '<';
  text.PropertyLines[0].chars[3].wordstate := '<';
  Check(text.GetDocChain(0,0)='Exam');
  Check(text.GetDocChain(1,0)='xam');
  Check(text.GetDocChain(11,0)='t');
  Check(text.GetDocChain(12,0)='.');

  text.PropertyLines[0].chars[12].wordstate := '<';
  Check(text.GetDocChain(11,0)='t.');
  Check(text.GetDocChain(12,0)='.');

 //Positions
  Check(text.EndOfDocument=SourcePos(Length(text.Lines[text.Lines.Count-1]), text.Lines.Count-1));
  Check(text.EndOfLine(text.Lines.Count-1)=text.EndOfDocument);
  Check(text.EndOfLine(0)=SourcePos(Length(text.Lines[0]),0));
end;


function TEncodingTestcase.GetTestFilename(const AFilename: string): string;
begin
 //All encoding test files are stored in the same folder
  Result := 'Tests\encoding\'+AFilename;
end;

procedure TEncodingTestCase.LoadFile(const AFilename: string; AEncoding: byte);
begin
  if AEncoding=FILETYPE_UNKNOWN then
    Check(Conv_DetectTypeEx('Tests\encoding\'+AFilename, AEncoding)
      or (AEncoding<>FILETYPE_UNKNOWN),
      'Cannot guess file encoding.');

 //All encoding test files are stored in the same folder
  text.LoadText(GetTestFilename(AFilename), AEncoding, amNone);
end;

{ All unicode text files contain the same text, so we run the same series of tests
to verify that they were decoded properly.
Expand the text to include various corner cases. Do not cover Ruby or any extended
parsing here. }
procedure TEncodingTestCase.VerifyText(const AFilename: string; AEncoding: byte);
begin
  LoadFile(AFilename, AEncoding);
  Check(text.Lines.Count=3);
  Check(text.PropertyLines.Count=3);
  Check(text.Lines[0].StartsWith('世間体を気にするのは'));
  Check(text.Lines[2].EndsWith('女子中学生だ。'));
end;

{ Ascii text is different since it can't contain unicode }
procedure TEncodingTestCase.VerifyAscii(const AFilename: string; AEncoding: byte);
begin
  LoadFile(AFilename, AEncoding);
  Check(text.Lines.Count=3);
  Check(text.PropertyLines.Count=3);
  Check(text.Lines[0].StartsWith('Example ansi'));
  Check(text.Lines[2].EndsWith('other line.'));
end;

{ With ACP we cannot verify ACP text because the active codepage can be different
 on the PC where tests are run, but at least we check what we can }
procedure TEncodingTestCase.VerifyAcp(const AFilename: string; AEncoding: byte);
begin
  LoadFile(AFilename, AEncoding);
  Check(text.Lines.Count=4);
  Check(text.PropertyLines.Count=4);
  Check(text.Lines[0].StartsWith('Example ansi'));
  Check(text.Lines[2].EndsWith('other line.'));
end;

{ Load the file, save it in the same encoding to a temporary folder and then
 compare byte-by-byte to the original file.
 Realistically, there will be cases when some of the nuances are lost. If this
 happens another test might be needed to load the file back and compare as data }
procedure TEncodingTestCase.LoadSaveCompare(const AFilename: string;
  AEncoding: byte; ABom: boolean; const ATestComment: string = '');
var tempDir: string;
  stream: TStream;
begin
  LoadFile(AFilename, AEncoding);
  tempDir := CreateRandomTempDir();
  try
    stream := TFileStream.Create(tempDir+'\'+AFilename, fmCreate);
    try
      text.SaveText(amDefault, TTextSaveFormat.Create(AEncoding, not ABom),
        stream);
    finally
      FreeAndNil(stream);
    end;
    Check(CompareFiles(GetTestFilename(AFilename), tempDir+'\'+AFilename));
  finally
    DeleteDirectory(tempDir);
  end;
end;

{ Simple loading }
procedure TEncodingTestCase.Ascii;
begin
  VerifyAscii('ascii.txt', FILETYPE_ASCII);
end;

procedure TEncodingTestCase.UTF8;
begin
  VerifyText('utf8.txt', FILETYPE_UTF8);
end;

procedure TEncodingTestCase.UTF8Sign;
begin
  VerifyText('utf8sign.txt', FILETYPE_UTF8);
end;

procedure TEncodingTestCase.UTF16LE;
begin
  VerifyText('utf16le.txt', FILETYPE_UTF16LE);
end;

procedure TEncodingTestCase.UTF16LESign;
begin
  VerifyText('utf16lesign.txt', FILETYPE_UTF16LE);
end;

procedure TEncodingTestCase.UTF16BE;
begin
  VerifyText('utf16be.txt', FILETYPE_UTF16BE);
end;

procedure TEncodingTestCase.UTF16BESign;
begin
  VerifyText('utf16besign.txt', FILETYPE_UTF16BE);
end;

procedure TEncodingTestCase.EUC;
begin
  VerifyText('euc.txt', FILETYPE_EUC);
end;

procedure TEncodingTestCase.ShiftJis;
begin
  VerifyText('shiftjis.txt', FILETYPE_SJS);
end;

procedure TEncodingTestCase.Acp;
begin
  VerifyAcp('acp.txt', FILETYPE_ACP);
end;

{ Guess* versions make converter guess the encoding }
procedure TEncodingTestCase.GuessAscii;
begin
  VerifyAscii('ascii.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessUTF8;
begin
  VerifyText('utf8.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessUTF8Sign;
begin
  VerifyText('utf8sign.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessUTF16LE;
begin
  VerifyText('utf16le.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessUTF16LESign;
begin
  VerifyText('utf16lesign.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessUTF16BE;
begin
 //UTF16BE is not being detected at this point, so this test always fails.
  VerifyText('utf16be.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessUTF16BESign;
begin
  VerifyText('utf16besign.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessEUC;
begin
  VerifyText('euc.txt', FILETYPE_UNKNOWN);
end;

procedure TEncodingTestCase.GuessShiftJis;
begin
  VerifyText('shiftjis.txt', FILETYPE_UNKNOWN);
end;

{ Save* to load, then save, then compare to original file }
procedure TEncodingTestCase.SaveAscii;
begin
  LoadSaveCompare('ascii.txt', FILETYPE_ASCII, false);
end;

procedure TEncodingTestCase.SaveUTF8;
begin
  LoadSaveCompare('utf8.txt', FILETYPE_UTF8, false);
end;

procedure TEncodingTestCase.SaveUTF8Sign;
begin
  LoadSaveCompare('utf8sign.txt', FILETYPE_UTF8, true);
end;

procedure TEncodingTestCase.SaveUTF16LE;
begin
  LoadSaveCompare('utf16le.txt', FILETYPE_UTF16LE, false);
end;

procedure TEncodingTestCase.SaveUTF16LESign;
begin
  LoadSaveCompare('utf16lesign.txt', FILETYPE_UTF16LE, true);
end;

procedure TEncodingTestCase.SaveUTF16BE;
begin
  LoadSaveCompare('utf16be.txt', FILETYPE_UTF16BE, false);
end;

procedure TEncodingTestCase.SaveUTF16BESign;
begin
  LoadSaveCompare('utf16besign.txt', FILETYPE_UTF16BE, true);
end;

procedure TEncodingTestCase.SaveEUC;
begin
  LoadSaveCompare('euc.txt', FILETYPE_EUC, false);
end;

procedure TEncodingTestCase.SaveShiftJis;
begin
  LoadSaveCompare('shiftjis.txt', FILETYPE_SJS, false);
end;

procedure TEncodingTestCase.SaveAcp;
begin
  LoadSaveCompare('acp.txt', FILETYPE_ACP, false);
end;


{ Ruby text }

function TRubyTextTestCase.GetTestFilename(const AFilename: string): string;
begin
  Result := 'Tests\rubywtt\'+AFilename;
end;

procedure TRubyTextTestCase.SaveCompare(const AFilename: string;
  AAnnotMode: TTextAnnotMode; const ATestComment: string = '');
var tempDir: string;
  stream: TStream;
begin
  tempDir := CreateRandomTempDir();
  try
    stream := TFileStream.Create(tempDir+'\'+AFilename, fmCreate);
    try
      text.SaveText(AAnnotMode, TRubyTextFormat.Create(FILETYPE_UTF16LE, false),
        stream);
    finally
      FreeAndNil(stream);
    end;
    Check(CompareFiles(GetTestFilename(AFilename), tempDir+'\'+AFilename),
      ATestComment);
  finally
    DeleteDirectory(tempDir);
  end;
end;

{ Saves the contents as WTT, reloads it into another TWakanText and compares
 the contents to the one after reloading.
 We cannot directly compare WTT files since some fields (char.db version) may
 change + local dictionary list may be indexed differently. }
procedure TRubyTextTestCase.SaveReloadCompareDataWtt();
var tempDir: string;
  stream: TStream;
  text2: TWakanText;
begin
  tempDir := CreateRandomTempDir();
  try
    stream := TFileStream.Create(tempDir+'\temp.wtt', fmCreate);
    try
      text.SaveWakanText(stream);
    finally
      FreeAndNil(stream);
    end;

    text2 := nil;
    stream := nil;
    try
      text2 := TWakanText.Create;
      stream := TFileStream.Create(tempDir+'\temp.wtt', fmOpenRead);
      text2.LoadWakanText(stream);
      CompareData(text2);
    finally
      FreeAndNil(text2);
      FreeAndNil(stream);
    end;
  finally
    DeleteDirectory(tempDir);
  end;
end;

{ Checks to do with standard text when loaded without and with parsing Ruby. }
procedure TRubyTextTestCase.CheckNoRuby;
begin
  Check(text.Lines.Count=19);
  Check(text.Lines[1].StartsWith('学校《がっこう》から帰宅《きたく》する'));
  Check(text.Lines[2].EndsWith('女子《じょし》｜中学生《ちゅうがくせい》だ。'));
  Check(text.Lines[5].StartsWith('《ちゅうがくせい》だ。'));
  Check(text.Lines[6].StartsWith('近所の｜《ちゅうがくせい》だ。'));
  Check(text.Lines[18].StartsWith('近所》きん》じょ《きん《じょ｜中学生《《｜がくせい'));
end;

procedure TRubyTextTestCase.CheckRuby;
var i: integer;
begin
  Check(text.Lines.Count=19);
  Check(text.Lines[1].StartsWith('学校から帰宅する'));
  Check(text.Lines[2].EndsWith('女子中学生だ。'));
  Check(text.Lines[5].StartsWith(UH_RUBY_PLACEHOLDER+'だ。'));
  Check(text.Lines[6].StartsWith('近所の'+UH_RUBY_PLACEHOLDER+'だ。'));
  Check(text.Lines[18].StartsWith('近所》きん》じょ《きん《じょ｜中学生《《｜がくせい'));

 //Normal ruby
  Check(text.PropertyLines[1].chars[0].ruby='がっこう');
  Check(text.PropertyLines[1].chars[1].wordstate='<');
  Check(text.PropertyLines[1].chars[2].wordstate<>'<');
  Check(text.PropertyLines[1].chars[4].ruby='きたく');

 //Ruby with no base (various)
  Check(text.PropertyLines[5].chars[0].ruby='ちゅうがくせい');
  Check(text.PropertyLines[6].chars[3].ruby='ちゅうがくせい');

 { Ruby parsing quality will mostly be tested by restoring the file and comparing
  to the original one. For now we'll just check that all valid ruby was parsed away }
  for i := 0 to 17 do begin
    Check(not text.Lines[i].Contains('《'), 'Not all valid ruby was parsed away');
    Check(not text.Lines[i].Contains('》'), 'Not all valid ruby was parsed away');
    Check(not text.Lines[i].Contains('｜'), 'Not all valid ruby was parsed away');
  end;

 { Broken ruby line must have no parsed ruby }
  for i := 0 to text.PropertyLines[18].charcount-1 do
    Check(text.PropertyLines[18].chars[i].ruby='');
end;

{ Loads ruby-text file without parsing ruby }
procedure TRubyTextTestCase.TextNoRuby;
begin
  text.Clear;
  text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amNone);
  CheckNoRuby;

 //it shouldn't matter whether we use amNone or amDefault
  SaveCompare('rubytext.txt', amNone, 'Saving back with amNone');
  SaveCompare('rubytext.txt', amDefault, 'Saving back with amDefault');
end;

{ Loads ruby-text file and parses ruby }
procedure TRubyTextTestCase.TextRuby;
begin
  text.Clear;
  text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
  CheckRuby;

  SaveCompare('norubytext.txt', amNone, 'Saving back with amNone');
  SaveCompare('rubytext.txt', amDefault, 'Saving back with amDefault');
end;

{ Loads ruby txt, saves as WTT, loads back and compares. This tests that
 saving and loading does not lose any info }
procedure TRubyTextTestCase.WttSaveReload;
begin
  text.Clear;
  text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
  SaveReloadCompareDataWtt();
end;

{ Loads WTT with freeform ruby }
procedure TRubyTextTestCase.WttRuby;
begin
  text.Clear;
  text.LoadWakanText(GetTestFilename('rubytext.wtt'));
  CheckRuby(); //assume the same text
  SaveCompare('rubytext.txt', amDefault, 'Saving to ruby text and comparing');
  SaveReloadCompareDataWtt();
end;

{ Loads WTT with dictionary references }
procedure TRubyTextTestCase.WttDict;
begin
  text.Clear;
  text.LoadWakanText(GetTestFilename('dicttext.wtt'));

 //Run some checks
  Check(text.Lines[0][1]=WideChar($3000));
  Check(text.PropertyLines[0].chars[1].learnstate=2);
  Check(text.PropertyLines[0].chars[1].dicidx=166076);
  Check(text.PropertyLines[0].chars[1].docdic=0);
  Check(text.PropertyLines[0].chars[1].wordstate='F');
  Check(text.PropertyLines[0].chars[2].wordstate='<');

  SaveReloadCompareDataWtt();
end;

{ Tries to load samples of files saved in older formats. }
procedure TRubyTextTestCase.WttOlderVersions;
begin
 { For now there's no older formats which we can load.
  'JaLeT translated text' version is hopelessly outdated and not documented. }
  Check(true);
end;

{ Export formats }

function TExportTestCase.GetTestFilename(const AFilename: string): string;
begin
 //All encoding test files are stored in the same folder
  Result := 'Tests\format\'+AFilename;
end;

procedure TExportTestCase.LoadSave(const AFilename: string;
  AFormat: TTextSaveFormat; const ATestComment: string);
var tempDir: string;
  stream: TStream;
begin
 //Load text and parse Ruby
  text.Clear;
  text.LoadText(GetTestFilename('_source.txt'), FILETYPE_UTF16LE, amRuby);

  tempDir := CreateRandomTempDir();
  try
    stream := TFileStream.Create(tempDir+'\'+AFilename, fmCreate);
    try
      text.SaveText(amDefault, AFormat, stream);
    finally
      FreeAndNil(stream);
    end;
  finally
    DeleteDirectory(tempDir);
  end;
end;

procedure TExportTestCase.LoadSaveCompare(const AFilename: string;
  AFormat: TTextSaveFormat; const ATestComment: string);
var tempDir: string;
  stream: TStream;
begin
 //Load text and parse Ruby
  text.Clear;
  text.LoadText(GetTestFilename('_source.txt'), FILETYPE_UTF16LE, amRuby);

  tempDir := CreateRandomTempDir();
  try
    stream := TFileStream.Create(tempDir+'\'+AFilename, fmCreate);
    try
      text.SaveText(amDefault, AFormat, stream);
    finally
      FreeAndNil(stream);
    end;
    Check(CompareFiles(GetTestFilename(AFilename), tempDir+'\'+AFilename), ATestComment);
  finally
    DeleteDirectory(tempDir);
  end;
end;

procedure TExportTestCase.KanaOnly;
begin
  LoadSaveCompare('kanaonly.txt', TKanaOnlyFormat.Create(FILETYPE_UTF16LE,false), 'Without spaces');
end;

procedure TExportTestCase.KanaOnlySpaces;
begin
  LoadSaveCompare('kanaonlysp.txt', TKanaOnlyFormat.Create(FILETYPE_UTF16LE,true), 'With spaces');
end;

procedure TExportTestCase.KanjiOnly;
begin
  LoadSaveCompare('kanjionly.txt', TKanjiOnlyFormat.Create(FILETYPE_UTF16LE,false));
end;

procedure TExportTestCase.KanjiKana;
begin
  LoadSaveCompare('kanjikana.txt', TKanjiKanaFormat.Create(FILETYPE_UTF16LE,false));
end;

procedure TExportTestCase.Html;
begin
  LoadSaveCompare('html.txt', THtmlFormat.Create([]), 'Full document');
end;

procedure TExportTestCase.HtmlFragm;
begin
  LoadSaveCompare('htmlfragm.txt', THtmlFormat.Create([hoClipFragment]), 'Clip fragment');
end;

procedure TExportTestCase.OpenDocumentContent;
begin
  LoadSaveCompare('odtcontent.xml', TOpenDocumentContentFormat.Create());
end;

procedure TExportTestCase.OpenDocument;
begin
 { ODT is a zip file, it stores creation/last write dates of all its contents,
  so there's no point comparing it against the reference. It will not be identical.
  Let's at least check that Save works }
  LoadSave('odt.odt', TOpenDocumentFormat.Create());
end;


{ Paste }

function TPasteTestCase.GetTestFilename(const AFilename: string): string;
begin
  Result := 'Tests\rubywtt\'+AFilename;
end;

{ Pastes the specified document at the specified position and runs integrity checks.
 Tries to be broad in what it accepts (i.e. empty documents, with no docdics, etc)
 NOTE: Afterwards, this document is considered scrapped and has to be rebuilt }
procedure TPasteTestCase.PasteAndTest(text2: TWakanText; ins: TSourcePos);
var  endpos: TSourcePos;
  oldCount, oldInsLen: integer;
  i, j, x_s: integer;
  locdics: array of integer;
  locdic: integer;
begin
  oldCount := text.Lines.Count;

 { Add some fake dictionaries to text1's list to make sure merging of lists is needed }
  if text2.docdic.Count>0 then
    text.docdic.Add(text2.docdic[0]); //this one will be common to both texts
  text.docdic.Add('no_way_text2_has_this_dict');

  oldInsLen := Length(text.Lines[ins.y]);
  text.PasteDoc(ins, text2, @endpos);

 //total lines
  Check(text.Lines.Count = oldCount + text2.Lines.Count - 1);

 //end position
  Check(endpos.y = ins.y + text2.Lines.Count - 1);
  Check(endpos.x = Length(text2.Lines[text2.Lines.Count-1]));

 //insertion start and end line lengths
  Check(Length(text.Lines[ins.y])=ins.x+Length(text2.Lines[0])); //length = insertion offset + first line length
  Check(text.PropertyLines[ins.y].charcount=Length(text.Lines[ins.y]));
  Check(Length(text.Lines[endpos.y])=endpos.x+oldInsLen-ins.x);
  Check(text.PropertyLines[endpos.y].charcount=Length(text.Lines[endpos.y]));

 //TODO: Что-то сделать с этими проверками. Мы же тут не знаем, какое содержимое
 //у файла. Либо вынести их в вызывающую функцию, либо как-то обобщить (на ходу
 //генерить то, на что проверяем? Или вообще проверять все места, где во вставляемом
 //текст был руби/цепочки, а вызывающие просто должны гарантировать, что вставляют
 //в такое место, где эти проверки имеют смысл (цепочка рвётся)?)
 //Наверное, второе.
 //contents
  Check(text.Lines[4].StartsWith('latin　誰か')); //new content from 5th symbol on
  Check(text.PropertyLines[4].chars[0].ruby='ちゅうがくせい'); //ruby must remain complete
  Check(text.PropertyLines[ins.y].chars[ins.x].wordstate<>'<');
    { word at the insertion point must not continue the chain, although if it
     was this way in text2[0] then it will, but it wasn't }
  Check(text.PropertyLines[endpos.y].chars[endpos.x+1].wordstate<>'<');
    { even though we inserted in the middle of the chain, the tail must
     be corrected to start with a fixed position at least }
 //TODO: Досюда.

 { Map all dictionaries to their local indexes.
  Paste() may optimize some dicts away if they were only declared but not used
  in the file.
  Therefore we don't crash if mapping returns -1, but instead later check that
  all dictionaries that are actually used are properly mapped. }
  SetLength(locdics, text2.docdic.Count);
  for i := 0 to Length(locdics)-1 do
    locdics[i] := text.docdic.IndexOf(text2.docdic[i]);

 { Check that all pasted characters reference valid dictionaries and that those
  dictionary indexes are localized versions of the original ones }
  for i := 0 to text2.Lines.Count-1 do begin
    if i=0 then x_s := ins.x else x_s := 0;
    for j := 0 to Length(text2.Lines[i])-1 do begin
      locdic := text2.PropertyLines[i].chars[j].docdic;
      Check((locdic>=0) and (locdic<Length(locdics)),
        'One of the dictionary indexes in the original file is invalid.'); //not a problem of pasting though
      locdic := locdics[locdic]; //localize index
      Check(locdic>=0, 'One of the dictionary indexes is used by a character '
        +'but haven''t been localized.');
      Check(text.PropertyLines[ins.y+i].chars[x_s+j].docdic=locdic,
        'Dictionary index localized incorrectly.');
    end;
  end;
end;

procedure TPasteTestCase.PasteWtt;
var text2: TWakanText;
  ins: TSourcePos;
begin
  text2 := TWakanText.Create;
  try
   { We need a text with dictionary references to test dictionary list merging. }
    text2.LoadWakanText(GetTestFilename('dicttext.wtt'));
    Check(text2.docdic.Count>0, 'We really need a file with non-empty dictionary list for this test.');

    text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
    PasteAndTest(text2, SourcePos({x=}5, {y=}4));

    text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
    PasteAndTest(text2, SourcePos({x=}0, {y=}0));

    text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
    PasteAndTest(text2, text.EndOfDocument);

    text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
    PasteAndTest(text2, text.EndOfLine(1));

    text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);
    text2.Clear;
    PasteAndTest(text2, SourcePos(5,4));
  finally
    FreeAndNil(text2);
  end;
end;

procedure TPasteTestCase.PasteText;
var text2: TWakanText;
begin
  text.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);

  text2 := TWakanText.Create;
  try
    text2.LoadText(GetTestFilename('rubytext.txt'), FILETYPE_UTF16LE, amRuby);

   //Simple text
    text.PasteText(SourcePos(4,5), 'test', CharacterLineProps([]), amNone);

  finally
    FreeAndNil(text2);
  end;
end;

function WakanTextTests: ITestSuite;
var ASuite: TTestSuite;
begin
  ASuite := TTestSuite.create('JWBWakanText');
  ASuite.addTest(TSourcePosTestCase.Suite);
  ASuite.addTest(TSourceBlockTestCase.Suite);
  ASuite.addTest(TLinesTestCase.Suite);
  ASuite.addTest(TEncodingTestCase.Suite);
  ASuite.addTest(TRubyTextTestCase.Suite);
  ASuite.addTest(TExportTestCase.Suite);
  ASuite.addTest(TPasteTestCase.Suite);
  Result := ASuite;
end;

initialization
  RegisterTest(WakanTextTests);

end.
