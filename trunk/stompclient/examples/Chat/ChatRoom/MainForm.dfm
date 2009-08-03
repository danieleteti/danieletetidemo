object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 319
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    483
    319)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 57
    Height = 13
    Caption = 'Room Name'
  end
  object EditRoomName: TEdit
    Left = 8
    Top = 27
    Width = 225
    Height = 21
    TabOrder = 0
    Text = 'chatroomname'
  end
  object Button1: TButton
    Left = 239
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Create Room'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo: TMemo
    Left = 8
    Top = 64
    Width = 459
    Height = 247
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    ExplicitWidth = 306
  end
  object Button2: TButton
    Left = 320
    Top = 25
    Width = 97
    Height = 25
    Caption = 'Shutdown Room'
    TabOrder = 3
    OnClick = Button2Click
  end
end
