object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 423
  ClientWidth = 566
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    566
    423)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 111
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 160
    Top = 138
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
    Height = 129
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
    Width = 321
    Height = 129
    ItemHeight = 13
    TabOrder = 8
  end
  object ListView1: TListView
    Left = 287
    Top = 18
    Width = 266
    Height = 95
    Columns = <
      item
        AutoSize = True
        Caption = 'Tipo'
      end
      item
        Caption = 'Numero'
        Width = 100
      end>
    FullDrag = True
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 9
    ViewStyle = vsReport
  end
  object Edit3: TEdit
    Left = 160
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 10
    Text = 'Edit1'
  end
  object ComboBox1: TComboBox
    Left = 9
    Top = 99
    Width = 136
    Height = 21
    Style = csDropDownList
    TabOrder = 11
    OnChange = ComboBox1CloseUp
    OnCloseUp = ComboBox1CloseUp
  end
  object ListView2: TListView
    Left = 89
    Top = 303
    Width = 464
    Height = 106
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Nome'
        Width = 110
      end
      item
        Caption = 'Cognome'
        Width = 110
      end
      item
        Caption = 'Salario'
        Width = 110
      end
      item
        Caption = 'Eta'
        Width = 110
      end>
    FullDrag = True
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 12
    ViewStyle = vsReport
  end
end
