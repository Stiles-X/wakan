object fDictImport: TfDictImport
  Left = 184
  Top = 231
  BorderStyle = bsDialog
  Caption = '#00071^eDictionary import'
  ClientHeight = 548
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 227
    Height = 13
    Caption = '#00072^eFile name (without extension):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 153
    Height = 13
    Caption = '#00073^eDictionary name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 218
    Height = 13
    Caption = '#00074^eIncluded EDICT format files:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 288
    Width = 104
    Height = 13
    Caption = '#00075^eVersion:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 392
    Width = 126
    Height = 13
    Caption = '#00035^eDescription:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 416
    Width = 58
    Height = 13
    Caption = 'Copyright:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtDictFilename: TEdit
    Left = 208
    Top = 8
    Width = 209
    Height = 21
    TabOrder = 0
  end
  object edtDictName: TEdit
    Left = 128
    Top = 32
    Width = 289
    Height = 21
    TabOrder = 1
  end
  object lbFiles: TListBox
    Left = 8
    Top = 72
    Width = 409
    Height = 209
    ItemHeight = 13
    TabOrder = 2
  end
  object edtVersion: TEdit
    Left = 136
    Top = 288
    Width = 281
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object rgPriority: TRadioGroup
    Left = 8
    Top = 344
    Width = 409
    Height = 41
    Caption = '#00076^ePriority'
    Columns = 5
    ItemIndex = 0
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4')
    TabOrder = 4
  end
  object edtDescription: TEdit
    Left = 136
    Top = 392
    Width = 393
    Height = 21
    TabOrder = 5
    Text = 'Edit1'
  end
  object edtCopyright: TEdit
    Left = 136
    Top = 416
    Width = 393
    Height = 21
    TabOrder = 6
    Text = 'Edit1'
  end
  object btnBuild: TBitBtn
    Left = 88
    Top = 512
    Width = 113
    Height = 25
    Caption = '#00077^eBuild'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 7
    OnClick = btnBuildClick
  end
  object btnCancel: TBitBtn
    Left = 344
    Top = 512
    Width = 105
    Height = 25
    Cancel = True
    Caption = '#00007^eCancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object btnAddFile: TButton
    Left = 424
    Top = 72
    Width = 105
    Height = 25
    Caption = '#00078^eAdd'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = btnAddFileClick
  end
  object btnRemoveFile: TButton
    Left = 424
    Top = 104
    Width = 105
    Height = 25
    Caption = '#00079^eRemove'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = btnRemoveFileClick
  end
  object rgLanguage: TRadioGroup
    Left = 8
    Top = 304
    Width = 409
    Height = 41
    Caption = '#00080^eLanguage'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '#00081^eJapanese'
      '#00082^eMandarin chinese')
    TabOrder = 11
  end
  object cbAddWordIndex: TCheckBox
    Left = 8
    Top = 440
    Width = 513
    Height = 17
    Caption = '#00083^eBuild with word index (allows English searching)'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object cbAddCharacterIndex: TCheckBox
    Left = 8
    Top = 464
    Width = 513
    Height = 17
    Caption = 
      '#00084^eBuild with character index (enables character compounds ' +
      'display)'
    Checked = True
    State = cbChecked
    TabOrder = 13
  end
  object cbAddFrequencyInfo: TCheckBox
    Left = 8
    Top = 488
    Width = 513
    Height = 17
    Caption = '#00914^eBuild with frequency information (requires WORDFREQ_CK)'
    TabOrder = 14
  end
  object AddFileDialog: TOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 456
    Top = 144
  end
end
