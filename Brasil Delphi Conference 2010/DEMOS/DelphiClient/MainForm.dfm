object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Customers Manager MONITOR'
  ClientHeight = 316
  ClientWidth = 714
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 714
    Height = 316
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitWidth = 573
    ExplicitHeight = 368
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 712
      Height = 48
      Align = alTop
      Caption = 'Orders'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 571
      object Button1: TButton
        Left = 5
        Top = 1
        Width = 196
        Height = 40
        Action = actOrders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object sg: TStringGrid
      Left = 1
      Top = 49
      Width = 712
      Height = 266
      Align = alClient
      BorderStyle = bsNone
      DoubleBuffered = True
      DrawingStyle = gdsGradient
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 1
      ExplicitWidth = 571
      ExplicitHeight = 318
    end
  end
  object ActionList1: TActionList
    Left = 344
    Top = 104
    object actCustomers: TAction
      Caption = '&Refresh'
      OnExecute = actCustomersExecute
    end
    object actOrders: TAction
      Caption = 'GetOrders'
      OnExecute = actOrdersExecute
    end
    object actDetails: TAction
      Caption = 'actDetails'
    end
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 280
    Top = 192
  end
end
