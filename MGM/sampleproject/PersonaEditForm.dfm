object frmPersoneEdit: TfrmPersoneEdit
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 271
  ClientWidth = 523
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    523
    271)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 420
    Height = 253
    Anchors = [akLeft, akTop, akRight, akBottom]
    Shape = bsFrame
    ExplicitWidth = 281
    ExplicitHeight = 161
  end
  object OKBtn: TButton
    Left = 436
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    ExplicitLeft = 300
  end
  object CancelBtn: TButton
    Left = 436
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 300
  end
  object Edit1: TEdit
    Left = 24
    Top = 40
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
    Top = 152
    Width = 185
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
end
