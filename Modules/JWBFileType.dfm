object fFileType: TfFileType
  Left = 192
  Top = 111
  BorderStyle = bsDialog
  Caption = '#00888^eSelect file type'
  ClientHeight = 192
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rgType: TRadioGroup
    Left = 8
    Top = 8
    Width = 265
    Height = 145
    Caption = '#00889^eFile type'
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 160
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 200
    Top = 160
    Width = 75
    Height = 25
    Caption = '#00890^eCancel'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
