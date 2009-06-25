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
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
  end
  object vst: TVirtualStringTree
    Left = 16
    Top = 144
    Width = 452
    Height = 242
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 3
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Columns = <
      item
        Position = 0
        Width = 150
        WideText = 'xxxxxx'
      end
      item
        Position = 1
        Width = 150
        WideText = 'xxxxxx'
      end>
  end
end
