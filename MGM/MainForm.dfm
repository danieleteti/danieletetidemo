object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 340
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 79
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 160
    Top = 106
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 107
    Height = 25
    Caption = 'Change Actual'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 160
    Top = 18
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 8
    Top = 47
    Width = 107
    Height = 25
    Caption = 'Switch'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 160
    Top = 45
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object ListBox1: TListBox
    Left = 89
    Top = 168
    Width = 137
    Height = 164
    ItemHeight = 13
    TabOrder = 4
    OnClick = ListBox1Click
  end
  object Button3: TButton
    Left = 8
    Top = 169
    Width = 75
    Height = 25
    Caption = 'Add Person'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 231
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 7
    OnClick = Button5Click
  end
  object ListBox2: TListBox
    Left = 232
    Top = 168
    Width = 297
    Height = 164
    ItemHeight = 13
    TabOrder = 8
  end
end
