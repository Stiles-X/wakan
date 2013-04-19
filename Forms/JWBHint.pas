unit JWBHint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, WakanPaintbox;

{ Shows results from JWBUser.fUser dictionary lookup in another form,
 suited for giving the user hints as they type. }

type
  TfHint = class(TForm)
    PaintBox1: TWakanPaintbox;
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
  protected
    FShowing: boolean;
  public
    procedure ShowHint(pos: TPoint);
    procedure Hide; reintroduce;
  end;

var
  fHint: TfHint;

implementation
uses JWBStrings, JWBUnit, JWBUser, JWBSettings, Grids;

{$R *.DFM}

{ If configured to, shows hint at the position determined by APos.
 To hide it, simply call Hide(). }
procedure TfHint.ShowHint(pos: TPoint);
begin
  if not fSettings.cbShowEditorHint.Checked then begin
    Hide();
    exit;
  end;

  if pos.X+Self.Width>Screen.Width then pos.X:=Screen.Width-Self.Width;

  Self.Left:=pos.X;
  Self.Top:=pos.Y;

  if fSettings.cbHintMeaning.Checked then Self.Height:=44 else Self.Height:=22;

 //There's some trouble going on when the form is showing:
 //the host deactivates, tries to Hide us which leads to Hiding in the middle of Showing().
 //Until I fix this I'm keeping inherited solution of flags, James flags.
  FShowing := true;
  try
    Self.Show;
    Self.Invalidate;
  finally
    FShowing := false;
  end;
end;

procedure TfHint.Hide;
begin
  if FShowing then exit;
  if Visible then inherited Hide;
end;

procedure TfHint.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
var StringGrid1: TStringGrid;
  kanjis:FString;
  i:integer;
  cw,cwl:integer;
  curk:string;
  fs,fsl:integer;
  rect:TRect;
begin
  StringGrid1 := fUser.StringGrid1; //faster access

  PaintBox1.Canvas.Brush.Color:=Col('Editor_HintBack');
  cw:=-1;
  kanjis:='';
  for i:=1 to StringGrid1.RowCount-1 do
  begin
    if kanjis<>'' then kanjis:=kanjis+UH_IDG_SPACE;
    curk:=remexcl(copy(StringGrid1.Cells[1,i],2,length(StringGrid1.Cells[1,i])-1));
    if StringGrid1.Row=i then
    begin
      cw:=flength(kanjis);
      cwl:=flength(curk);
    end;
    kanjis:=kanjis+curk;
  end;
  fs:=18;
  fsl:=PaintBox1.Width div fs;
  while flength(kanjis)>fsl do
  begin
    if cw>1 then
    begin
      while fcopy(kanjis,1,1)<>UH_IDG_SPACE do
      begin
        fdelete(kanjis,1,1);
        dec(cw,1);
      end;
      fdelete(kanjis,1,1);
      kanjis:=UH_ELLIPSIS+kanjis;
    end else
    begin
      while fcopy(kanjis,flength(kanjis)-1,1)<>UH_IDG_SPACE do fdelete(kanjis,flength(kanjis)-1,1);
      fdelete(kanjis,flength(kanjis)-1,1);
      kanjis:=kanjis+UH_ELLIPSIS;
    end;
  end;
//  PaintBox1.Canvas.Font.Style:=[];
  PaintBox1.Canvas.Font.Color:=Col('Editor_HintText');
  DrawUnicode(PaintBox1.Canvas,2,2,fs,fcopy(kanjis,1,cw),FontJapaneseGrid);
//  PaintBox1.Canvas.Font.Style:=[fsBold];
  PaintBox1.Canvas.Brush.Color:=Col('Editor_HintSelected');
  rect.Left:=2+cw*fs;
  rect.Top:=2;
  rect.Bottom:=fs+2;
  rect.Right:=2+cw*fs+cwl*fs;
  PaintBox1.Canvas.FillRect(rect);
  DrawUnicode(PaintBox1.Canvas,2+cw*fs,2,fs,fcopy(kanjis,cw+1,cwl),FontJapaneseGrid);
//  PaintBox1.Canvas.Font.Style:=[];
  PaintBox1.Canvas.Brush.Color:=Col('Editor_HintBack');
  DrawUnicode(PaintBox1.Canvas,2+cw*fs+cwl*fs,2,fs,fcopy(kanjis,cw+cwl+1,flength(kanjis)-cwl-cw),FontJapaneseGrid);
  if fSettings.cbHintMeaning.Checked then
  begin
    PaintBox1.Canvas.Font.Name:=FontEnglish;
    PaintBox1.Canvas.Font.Height:=fs-4;
    rect.top:=fs+2;
    rect.left:=2;
    rect.right:=PaintBox1.Width-4;
    rect.bottom:=fs*2;
    PaintBox1.Canvas.TextRect(rect,2,fs+2,remmark(remexcl(StringGrid1.Cells[2,fUser.curword])));
  end;
end;


end.
