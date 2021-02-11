object frm_conf: Tfrm_conf
  Left = 0
  Top = 0
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 303
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object ValueListEditor1: TValueListEditor
    Left = 0
    Top = 0
    Width = 327
    Height = 303
    Align = alClient
    TabOrder = 0
    TitleCaptions.Strings = (
      #1055#1072#1088#1072#1084#1077#1090#1088
      #1047#1085#1072#1095#1077#1085#1080#1077)
    OnGetPickList = ValueListEditor1GetPickList
    OnKeyPress = FormKeyPress
    ColWidths = (
      150
      171)
    RowHeights = (
      18
      18)
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 96
    Top = 80
    object act_result_ok: TAction
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      ShortCut = 16397
      OnExecute = act_result_okExecute
    end
    object act_result_cancel: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100
      ShortCut = 27
      OnExecute = act_result_cancelExecute
    end
  end
  object ImageList1: TImageList
    Left = 112
    Top = 152
  end
end
