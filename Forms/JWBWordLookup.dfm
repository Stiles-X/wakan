inherited fWordLookup: TfWordLookup
  Left = 57
  Top = 137
  BorderStyle = bsSizeToolWin
  Caption = '#00642^eDictionary lookup'
  ClientHeight = 214
  ClientWidth = 704
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  OnShow = FormShow
  ExplicitWidth = 720
  ExplicitHeight = 248
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel: TPanel
    Width = 704
    Height = 214
    TabOrder = 2
    ExplicitWidth = 704
    ExplicitHeight = 214
    inherited btnGoToVocab: TSpeedButton
      Left = 425
      Top = 185
      ExplicitTop = 185
    end
    inherited btnAddToVocab: TSpeedButton
      Left = 521
      Top = 185
      ExplicitTop = 185
    end
    inherited btnCopyToClipboard: TSpeedButton
      Left = 617
      Top = 185
      ExplicitTop = 185
    end
    object btnMatchExact: TSpeedButton [3]
      Left = 231
      Top = 4
      Width = 23
      Height = 22
      Hint = '#00656^eSearch exact word (F5)'
      GroupIndex = 7
      Down = True
      Caption = 'A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnMatchExactClick
    end
    object btnMatchLeft: TSpeedButton [4]
      Left = 255
      Top = 4
      Width = 23
      Height = 22
      Hint = '#00657^eSearch beginning (F6)'
      GroupIndex = 7
      Caption = 'A+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnMatchExactClick
    end
    object btnMatchRight: TSpeedButton [5]
      Left = 279
      Top = 4
      Width = 23
      Height = 22
      Hint = '#00658^eSearch end (F7)'
      GroupIndex = 7
      Caption = '+A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnMatchExactClick
    end
    object btnMatchAnywhere: TSpeedButton [6]
      Left = 303
      Top = 4
      Width = 25
      Height = 22
      Hint = '#00930^eSearch middle'
      GroupIndex = 7
      Caption = '+A+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnMatchExactClick
    end
    object btnInflect: TSpeedButton [7]
      Left = 334
      Top = 4
      Width = 23
      Height = 22
      Hint = '#00661^eSearch for inflected words / conjugated verbs'
      AllowAllUp = True
      GroupIndex = 8
      Caption = 'Inf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbAutoPreview: TSpeedButton [8]
      Left = 358
      Top = 4
      Width = 33
      Height = 22
      Hint = 
        '#00662^eAuto-preview while typing (full search with arrow button' +
        ')'
      AllowAllUp = True
      GroupIndex = 9
      Caption = 'Auto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object btnDictGroup1: TSpeedButton [9]
      Left = 398
      Top = 4
      Width = 25
      Height = 22
      Hint = '#00663^eUse dictionaries in group 1 (Ctrl-1)'
      GroupIndex = 10
      Down = True
      Caption = 'D1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object btnDictGroup2: TSpeedButton [10]
      Left = 424
      Top = 4
      Width = 25
      Height = 22
      Hint = '#00664^eUse dictionaries in group 2 (Ctrl-2)'
      GroupIndex = 10
      Caption = 'D2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object btnDictGroup3: TSpeedButton [11]
      Left = 450
      Top = 4
      Width = 25
      Height = 22
      Hint = '#00665^eUse dictionaries in group 3 (Ctrl-3)'
      GroupIndex = 10
      Caption = 'D3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel [12]
      Left = 604
      Top = 37
      Width = 92
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '#00666^eAll visible'
      Enabled = False
    end
    object Label3: TLabel [13]
      Left = 688
      Top = 17
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '0'
    end
    object SpeedButton6: TSpeedButton [14]
      Left = 8
      Top = 189
      Width = 123
      Height = 17
      Hint = '#00650^eCharacters in word'
      AllowAllUp = True
      Anchors = [akLeft, akBottom]
      GroupIndex = 6
      Caption = '#00651^eChar. in word'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton6Click
    end
    object SpeedButton9: TSpeedButton [15]
      Left = 136
      Top = 189
      Width = 130
      Height = 17
      Hint = '#00062^eAdd to vocabulary'
      AllowAllUp = True
      Anchors = [akLeft, akBottom]
      GroupIndex = 4
      Caption = '#00315^eExamples'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton9Click
    end
    object SpeedButton1: TSpeedButton [16]
      Left = 11
      Top = 4
      Width = 23
      Height = 22
    end
    object btnLookupClip: TSpeedButton [17]
      Left = 152
      Top = 4
      Width = 73
      Height = 22
      Hint = '#00647^eSearch by Kanji stored in clipboard (F4)'
      AllowAllUp = True
      GroupIndex = 1
      Caption = '#00289^eBy clipboard'
      PopupMenu = pmLookupMode
      OnClick = btnLookupClipClick
    end
    inherited BlankPanel: TBlankPanel
      Top = 62
      Width = 687
      Height = 123
      ExplicitTop = 62
      ExplicitWidth = 687
      ExplicitHeight = 123
    end
    inherited StringGrid: TWakanWordGrid
      Top = 63
      Width = 685
      Height = 121
      ExplicitTop = 63
      ExplicitWidth = 685
      ExplicitHeight = 121
      ColWidths = (
        110
        138
        413)
    end
    object Edit1: TEdit
      Left = 8
      Top = 32
      Width = 616
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = Edit1Change
      OnClick = Edit1Click
    end
    object btnSearch: TBitBtn
      Left = 626
      Top = 32
      Width = 70
      Height = 25
      Hint = 
        '#00668^eSearch results did not fit one page, click to display ev' +
        'erything'
      Anchors = [akTop, akRight]
      Caption = '#00669^eSearch'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333033333
        33333333373F33333333333330B03333333333337F7F33333333333330F03333
        333333337F7FF3333333333330B00333333333337F773FF33333333330F0F003
        333333337F7F773F3333333330B0B0B0333333337F7F7F7F3333333300F0F0F0
        333333377F73737F33333330B0BFBFB03333337F7F33337F33333330F0FBFBF0
        3333337F7333337F33333330BFBFBFB033333373F3333373333333330BFBFB03
        33333337FFFFF7FF3333333300000000333333377777777F333333330EEEEEE0
        33333337FFFFFF7FF3333333000000000333333777777777F33333330000000B
        03333337777777F7F33333330000000003333337777777773333}
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = btnSearchClick
    end
    object btnLookupMode: TButton
      Left = 11
      Top = 4
      Width = 135
      Height = 22
      Hint = 
        '#01133^Search by reading, writing or meaning, depending on what ' +
        'you type'
      Caption = '#01132^Any matches'
      DropDownMenu = pmLookupMode
      Style = bsSplitButton
      TabOrder = 4
      OnClick = btnLookupModeClick
    end
  end
  object pnlDockExamples: TPanel [1]
    Left = 0
    Top = 214
    Width = 704
    Height = 0
    Align = alBottom
    BevelOuter = bvNone
    FullRepaint = False
    TabOrder = 0
  end
  object Panel3: TPanel [2]
    Left = 704
    Top = 0
    Width = 0
    Height = 214
    Align = alRight
    BevelOuter = bvNone
    FullRepaint = False
    TabOrder = 1
  end
  inherited pmPopup: TPopupMenu
    Left = 32
    Top = 40
  end
  inherited ilImages: TImageList
    Left = 96
    Top = 40
    Bitmap = {
      494C010103000800740010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FFFFFF0000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FFFFFF0000000000FFFFFF0000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF0000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00FFFFFF0000FFFF0000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      00000000FF000000FF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFE7F8FE3F0000
      1FFFE7F8F81F0000041F81FFF40F0000000F81FCE0070000000FE7FC80030000
      0007E7FF400100000001FFFC000000000000FEFC000000000001FE7F80010000
      003F8013C0030000FC7F8013E00F0000FFFFFE7FF07F0000FFFFFEF8F8FF0000
      FFFFFFF8FFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object pmLookupMode: TPopupMenu
    Images = ilImages
    OnPopup = pmPopupPopup
    Left = 32
    Top = 96
    object miLookupAuto: TMenuItem
      AutoCheck = True
      Caption = '#01132^Auto/all'
      Checked = True
      GroupIndex = 1
      Hint = 
        '#01133^Search by reading, writing or meaning, depending on what ' +
        'you type'
      RadioItem = True
      OnClick = miLookupAutoClick
    end
    object miLookupJtoE: TMenuItem
      AutoCheck = True
      Caption = '#00644^eJ -> E'
      GroupIndex = 1
      Hint = '#00643^Search by japanese reading (F2)'
      RadioItem = True
      OnClick = miLookupJtoEClick
    end
    object miLookupEtoJ: TMenuItem
      AutoCheck = True
      Caption = '#00646^e&E -> J'
      GroupIndex = 1
      Hint = '#00645^Search by english meaning (F3)'
      RadioItem = True
      OnClick = miLookupEtoJClick
    end
  end
end
