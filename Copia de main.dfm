object MainForm: TMainForm
  Left = 192
  Top = 107
  Width = 605
  Height = 471
  Caption = 'HisQ.EXE v 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object currentcurve: TLabel
    Left = 488
    Top = 20
    Width = 60
    Height = 13
    Caption = 'currentcurve'
  end
  object Label1: TLabel
    Left = 376
    Top = 52
    Width = 71
    Height = 13
    Caption = 'Top current (A)'
  end
  object SourceBLQ: TEdit
    Left = 128
    Top = 16
    Width = 241
    Height = 21
    TabOrder = 0
    Text = 'e:\dat00\O27\O27_A000.blq'
  end
  object Start: TButton
    Left = 396
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = StartClick
  end
  object G: TxyyGraph
    Left = 36
    Top = 80
    Width = 533
    Height = 321
    Cursor = crCross
    BackgroundColor = clWhite
    Title = 'xyyGraph'
    AutoScaling = True
    AntiFlicker = False
  end
  object Copy: TButton
    Left = 36
    Top = 412
    Width = 129
    Height = 25
    Caption = 'Copy to Clipboard'
    TabOrder = 3
    OnClick = CopyClick
  end
  object Select: TButton
    Left = 32
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Select BLQ'
    TabOrder = 4
    OnClick = SelectClick
  end
  object Even: TCheckBox
    Left = 128
    Top = 52
    Width = 97
    Height = 17
    Caption = 'Even curves'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object Odd: TCheckBox
    Left = 228
    Top = 52
    Width = 97
    Height = 17
    Caption = 'Odd curves'
    TabOrder = 6
  end
  object MaxCurrent: TEdit
    Left = 456
    Top = 48
    Width = 101
    Height = 21
    TabOrder = 7
    Text = '10E-6'
  end
  object OpenDlg: TOpenDialog
    DefaultExt = 'blq'
    Filter = '*.BLQ|*.BLQ'
    Left = 48
    Top = 44
  end
end
