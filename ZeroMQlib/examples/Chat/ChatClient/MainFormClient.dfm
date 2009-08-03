object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 412
  ClientWidth = 511
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    511
    412)
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 137
    Height = 21
    TabOrder = 0
    Text = 'localhost'
    TextHint = 'Host Name'
  end
  object Edit2: TEdit
    Left = 151
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'ChatRoomName'
    TextHint = 'Room Name'
  end
  object Button1: TButton
    Left = 405
    Top = 22
    Width = 99
    Height = 25
    Caption = 'Enter'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 278
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'daniele_teti'
    TextHint = 'Nickname'
  end
  object Memo1: TMemo
    Left = 8
    Top = 53
    Width = 494
    Height = 277
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clMenuBar
    Font.Charset = ANSI_CHARSET
    Font.Color = clHotLight
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    ExplicitWidth = 496
    ExplicitHeight = 233
  end
  object Memo2: TMemo
    Left = 8
    Top = 336
    Width = 389
    Height = 70
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    ExplicitTop = 326
    ExplicitWidth = 391
  end
  object Button2: TButton
    Left = 403
    Top = 336
    Width = 100
    Height = 68
    Anchors = [akRight, akBottom]
    Caption = 'Send'
    TabOrder = 6
    OnClick = Button2Click
    ExplicitLeft = 405
    ExplicitTop = 326
  end
  object tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrTimer
    Left = 432
    Top = 72
  end
end
