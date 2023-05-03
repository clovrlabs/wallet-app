class LightningFeesConfs {
  String _txtColorTitle;
  String _backArrowColor;
  String _txtSubtitleFees;
  String _checkBoxFees;
  String _txtEnforceFees;
  String _txtHintBaseFee;
  String _txtBaseFee;
  String _txtHintProportionalFee;
  String _txtProportionalFee;
  String _btBgResetColor;
  String _btTxtResetColor;
  String _btTxtSaveColor;
  String _btOutlineSaveColor;
  String _btOutlineResetColor;
  String _colorBgBanner;
  String _colorFrameBanner;
  String _txtColorBanner;
  String _bgColor;

  LightningFeesConfs({
    String txtColorTitle,
    String backArrowColor,
    String txtSubtitleFees,
    String checkBoxFees,
    String txtEnforceFees,
    String txtHintBaseFee,
    String txtBaseFee,
    String txtHintProportionalFee,
    String txtProportionalFee,
    String btBgResetColor,
    String btTxtResetColor,
    String btTxtSaveColor,
    String btOutlineSaveColor,
    String btOutlineResetColor,
    String colorBgBanner,
    String colorFrameBanner,
    String txtColorBanner,
    String bgColor,
  }) {
    _txtColorTitle = txtColorTitle;
    _backArrowColor = backArrowColor;
    _txtSubtitleFees = txtSubtitleFees;
    _checkBoxFees = checkBoxFees;
    _txtEnforceFees = txtEnforceFees;
    _txtHintBaseFee = txtHintBaseFee;
    _txtBaseFee = txtBaseFee;
    _txtHintProportionalFee = txtHintProportionalFee;
    _txtProportionalFee = txtProportionalFee;
    _btBgResetColor = btBgResetColor;
    _btTxtResetColor = btTxtResetColor;
    _btTxtSaveColor = btTxtSaveColor;
    _btOutlineSaveColor = btOutlineSaveColor;
    _btOutlineResetColor = btOutlineResetColor;
    _colorBgBanner = colorBgBanner;
    _colorFrameBanner = colorFrameBanner;
    _txtColorBanner = txtColorBanner;
    _bgColor = bgColor;
  }

  LightningFeesConfs.fromJson(dynamic json) {
    _txtColorTitle = json['txt_color_title'];
    _backArrowColor = json['back_arrow_color'];
    _txtSubtitleFees = json['txt_subtitle_fees'];
    _checkBoxFees = json['check_box_fees'];
    _txtEnforceFees = json['txt_enforce_fees'];
    _txtHintBaseFee = json['txt_hint_base_fee'];
    _txtBaseFee = json['txt_base_fee'];
    _txtHintProportionalFee = json['txt_hint_proportional_fee'];
    _txtProportionalFee = json['txt_proportional_fee'];
    _btBgResetColor = json['bt_bg_reset_color'];
    _btTxtResetColor = json['bt_txt_reset_color'];
    _btTxtSaveColor = json['bt_txt_save_color'];
    _btOutlineSaveColor = json['bt_outline_save_color'];
    _btOutlineResetColor = json['bt_outline_reset_color'];
    _colorBgBanner = json['color_bg_banner'];
    _colorFrameBanner = json['color_frame_banner'];
    _txtColorBanner = json['txt_color_banner'];
    _bgColor = json['bg_color'];
  }

  LightningFeesConfs copyWith({
    String txtColorTitle,
    String backArrowColor,
    String txtSubtitleFees,
    String checkBoxFees,
    String txtEnforceFees,
    String txtHintBaseFee,
    String txtBaseFee,
    String txtHintProportionalFee,
    String txtProportionalFee,
    String btBgResetColor,
    String btTxtResetColor,
    String btTxtSaveColor,
    String btOutlineSaveColor,
    String btOutlineResetColor,
    String colorBgBanner,
    String colorFrameBanner,
    String txtColorBanner,
    String bgColor,
  }) =>
      LightningFeesConfs(
        txtColorTitle: txtColorTitle ?? _txtColorTitle,
        backArrowColor: backArrowColor ?? _backArrowColor,
        txtSubtitleFees: txtSubtitleFees ?? _txtSubtitleFees,
        checkBoxFees: checkBoxFees ?? _checkBoxFees,
        txtEnforceFees: txtEnforceFees ?? _txtEnforceFees,
        txtHintBaseFee: txtHintBaseFee ?? _txtHintBaseFee,
        txtBaseFee: txtBaseFee ?? _txtBaseFee,
        txtHintProportionalFee:
            txtHintProportionalFee ?? _txtHintProportionalFee,
        txtProportionalFee: txtProportionalFee ?? _txtProportionalFee,
        btBgResetColor: btBgResetColor ?? _btBgResetColor,
        btTxtResetColor: btTxtResetColor ?? _btTxtResetColor,
        btTxtSaveColor: btTxtSaveColor ?? _btTxtSaveColor,
        btOutlineSaveColor: btOutlineSaveColor ?? _btOutlineSaveColor,
        btOutlineResetColor: btOutlineResetColor ?? _btOutlineResetColor,
        colorBgBanner: colorBgBanner ?? _colorBgBanner,
        colorFrameBanner: colorFrameBanner ?? _colorFrameBanner,
        txtColorBanner: txtColorBanner ?? _txtColorBanner,
        bgColor: bgColor ?? _bgColor,
      );

  String get bgColor => _bgColor;

  String get txtColorTitle => _txtColorTitle;

  String get backArrowColor => _backArrowColor;

  String get txtSubtitleFees => _txtSubtitleFees;

  String get checkBoxFees => _checkBoxFees;

  String get txtEnforceFees => _txtEnforceFees;

  String get txtHintBaseFee => _txtHintBaseFee;

  String get txtBaseFee => _txtBaseFee;

  String get txtHintProportionalFee => _txtHintProportionalFee;

  String get txtProportionalFee => _txtProportionalFee;

  String get btBgResetColor => _btBgResetColor;

  String get btTxtResetColor => _btTxtResetColor;

  String get btTxtSaveColor => _btTxtSaveColor;

  String get btOutlineSaveColor => _btOutlineSaveColor;

  String get btOutlineResetColor => _btOutlineResetColor;

  String get colorBgBanner => _colorBgBanner;

  String get colorFrameBanner => _colorFrameBanner;

  String get txtColorBanner => _txtColorBanner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['txt_color_title'] = _txtColorTitle;
    map['back_arrow_color'] = _backArrowColor;
    map['txt_subtitle_fees'] = _txtSubtitleFees;
    map['check_box_fees'] = _checkBoxFees;
    map['txt_enforce_fees'] = _txtEnforceFees;
    map['txt_hint_base_fee'] = _txtHintBaseFee;
    map['txt_base_fee'] = _txtBaseFee;
    map['txt_hint_proportional_fee'] = _txtHintProportionalFee;
    map['txt_proportional_fee'] = _txtProportionalFee;
    map['bt_bg_reset_color'] = _btBgResetColor;
    map['bt_txt_reset_color'] = _btTxtResetColor;
    map['bt_txt_save_color'] = _btTxtSaveColor;
    map['bt_outline_save_color'] = _btOutlineSaveColor;
    map['bt_outline_reset_color'] = _btOutlineResetColor;
    map['color_bg_banner'] = _colorBgBanner;
    map['color_frame_banner'] = _colorFrameBanner;
    map['txt_color_banner'] = _txtColorBanner;
    map['bg_color'] = _bgColor;
    return map;
  }
}
