object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 394
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit2: TEdit
    Left = 16
    Top = 59
    Width = 257
    Height = 21
    TabOrder = 0
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 16
    Top = 16
    Width = 257
    Height = 21
    TabOrder = 1
    Text = 'Edit3'
  end
  object Button1: TButton
    Left = 16
    Top = 86
    Width = 121
    Height = 25
    Caption = 'Create Speaker'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ListView1: TListView
    Left = 16
    Top = 117
    Width = 452
    Height = 228
    Columns = <>
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
  end
  object Button2: TButton
    Left = 16
    Top = 351
    Width = 121
    Height = 25
    Caption = 'Delete Speaker'
    TabOrder = 4
    OnClick = Button2Click
  end
end
