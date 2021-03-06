unit JWBPortableMode;
// UI to choose between portable or standalone mode

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, IniFiles, JWBStrings, JwbForms;

type
  TfPortableMode = class(TJwbForm)
    lblQuestion: TLabel;
    btnStandalone: TButton;
    lblStandaloneDescription: TLabel;
    btnPortable: TButton;
    lblPortableDescription: TLabel;
    procedure btnPortableClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnStandaloneClick(Sender: TObject);
  public
    class function SelectMode(AOwner: TComponent): string;
  end;

const
  MR_STANDALONE = 1001;
  MR_PORTABLE = 1002;

implementation
uses JWBCore, AppData;

{$R *.DFM}

procedure TfPortableMode.FormShow(Sender: TObject);
begin
  if not CanWriteWakanIni then begin
    SetButtonElevated(btnStandalone.Handle);
    SetButtonElevated(btnPortable.Handle);
  end;
end;

procedure TfPortableMode.btnStandaloneClick(Sender: TObject);
begin
  ModalResult := MR_STANDALONE;
end;

procedure TfPortableMode.btnPortableClick(Sender: TObject);
begin
  ModalResult := MR_PORTABLE;
end;

class function TfPortableMode.SelectMode(AOwner: TComponent): string;
var instance: TfPortableMode;
  mr: integer;
begin
  instance := TfPortableMode.Create(AOwner);
  try
    if AOwner = nil then
      AOwner := Application.MainForm;
    if (AOwner = nil) or not (AOwner is TForm) or not TForm(AOwner).Visible then
      instance.Position := poScreenCenter
    else
      instance.Position := poOwnerFormCenter;

    mr := instance.ShowModal;

    case mr of
      MR_STANDALONE: Result := 'standalone';
      MR_PORTABLE: Result := 'portable';
    else
      raise EAbort.Create('');
    end;
  finally
    FreeAndNil(instance);
  end;
end;


end.