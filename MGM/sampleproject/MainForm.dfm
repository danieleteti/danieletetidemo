object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 271
  ClientWidth = 561
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
  object ListView1: TListView
    AlignWithMargins = True
    Left = 3
    Top = 41
    Width = 555
    Height = 227
    Align = alClient
    Columns = <
      item
        Caption = 'Nome'
        Width = 200
      end
      item
        Caption = 'Domicilio'
        Width = 150
      end
      item
        Caption = 'Tipo'
        Width = 100
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 561
    Height = 38
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 3
      Top = 7
      Width = 102
      Height = 25
      Action = Action1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 111
      Top = 7
      Width = 102
      Height = 25
      Action = Action2
      TabOrder = 1
    end
    object Button3: TButton
      Left = 219
      Top = 7
      Width = 102
      Height = 25
      Action = Action3
      TabOrder = 2
    end
  end
  object ActionList1: TActionList
    Left = 256
    Top = 208
    object Action1: TAction
      Caption = 'New Persona'
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Edit Persona'
      OnExecute = Action2Execute
    end
    object Action3: TAction
      Caption = 'Delete Persona'
      OnExecute = Action3Execute
      OnUpdate = Action3Update
    end
    object Action4: TAction
      Caption = 'Action4'
    end
  end
end
