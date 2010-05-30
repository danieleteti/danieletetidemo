object frmPersoneEdit: TfrmPersoneEdit
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 385
  ClientWidth = 588
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    588
    385)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 217
    Height = 193
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 240
    Top = 8
    Width = 235
    Height = 193
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 19
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 24
    Top = 77
    Width = 40
    Height = 13
    Caption = 'Indirizzo'
  end
  object Label3: TLabel
    Left = 24
    Top = 141
    Width = 20
    Height = 13
    Caption = 'Tipo'
  end
  object Label4: TLabel
    Left = 256
    Top = 19
    Width = 29
    Height = 13
    Caption = 'Marca'
  end
  object Label5: TLabel
    Left = 256
    Top = 77
    Width = 36
    Height = 13
    Caption = 'Modello'
  end
  object Label6: TLabel
    Left = 256
    Top = 141
    Width = 119
    Height = 13
    Caption = 'Anno di Immatricolazione'
  end
  object OKBtn: TButton
    Left = 501
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    ExplicitLeft = 436
  end
  object CancelBtn: TButton
    Left = 501
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 436
  end
  object Edit1: TEdit
    Left = 24
    Top = 38
    Width = 185
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 24
    Top = 96
    Width = 185
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object Edit3: TEdit
    Left = 24
    Top = 160
    Width = 185
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
  object Edit4: TEdit
    Left = 256
    Top = 38
    Width = 185
    Height = 21
    TabOrder = 5
    Text = 'Edit1'
  end
  object Edit5: TEdit
    Left = 256
    Top = 96
    Width = 185
    Height = 21
    TabOrder = 6
    Text = 'Edit1'
  end
  object Edit6: TEdit
    Left = 256
    Top = 160
    Width = 185
    Height = 21
    TabOrder = 7
    Text = 'Edit1'
  end
  object ListView1: TListView
    Left = 8
    Top = 216
    Width = 467
    Height = 161
    Columns = <
      item
        Caption = 'Tipo'
        Width = 100
      end
      item
        Caption = 'Valore'
        Width = 100
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 8
    ViewStyle = vsReport
  end
end
