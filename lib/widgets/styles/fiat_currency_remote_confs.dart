class FiatCurrencyRemoteConfs {

  String _txtColorTitle;
  String _backArrowColor;
  String _checkboxColorActive;
  String _checkboxColorInactive;
  String _txtCurrency;
  String _txtColorAmountShort;
  String _txtColorAmountFull;
  String _icEqual;
  String _background;
  String _checkColorActive;

  FiatCurrencyRemoteConfs({
    String txtColorTitle,
    String backArrowColor,
    String checkboxColorActive,
    String checkboxColorInactive,
    String txtCurrency,
    String txtColorAmountShort,
    String txtColorAmountFull,
    String icEqual,
    String background,
    String checkColorActive,
  }) {
    _txtColorTitle = txtColorTitle;
    _backArrowColor = backArrowColor;
    _checkboxColorActive = checkboxColorActive;
    _checkboxColorInactive = checkboxColorInactive;
    _txtCurrency = txtCurrency;
    _txtColorAmountShort = txtColorAmountShort;
    _txtColorAmountFull = txtColorAmountFull;
    _icEqual = icEqual;
    _background = background;
    _checkColorActive = checkColorActive;
  }

  FiatCurrencyRemoteConfs.fromJson(Map<String, dynamic> json) {
    _txtColorTitle = json['txt_color_title'];
    _backArrowColor = json['back_arrow_color'];
    _checkboxColorActive = json['checkbox_color_active'];
    _checkboxColorInactive = json['checkbox_color_inactive'];
    _txtCurrency = json['txt_currency'];
    _txtColorAmountShort = json['txt_color_amount_short'];
    _txtColorAmountFull = json['txt_color_amount_full'];
    _icEqual = json['ic_equal'];
    _background = json['background'];
    _checkColorActive = json['check_color'];
  }

  FiatCurrencyRemoteConfs copyWith({
    String txtColorTitle,
    String backArrowColor,
    String checkboxColorActive,
    String checkboxColorInactive,
    String txtCurrency,
    String txtColorAmountShort,
    String txtColorAmountFull,
    String icEqual,
    String background,
  }) =>
      FiatCurrencyRemoteConfs(
        txtColorTitle: txtColorTitle ?? _txtColorTitle,
        backArrowColor: backArrowColor ?? _backArrowColor,
        checkboxColorActive: checkboxColorActive ?? _checkboxColorActive,
        checkboxColorInactive: checkboxColorInactive ?? _checkboxColorInactive,
        txtCurrency: txtCurrency ?? _txtCurrency,
        txtColorAmountShort: txtColorAmountShort ?? _txtColorAmountShort,
        txtColorAmountFull: txtColorAmountFull ?? _txtColorAmountFull,
        icEqual: icEqual ?? _icEqual,
        background: background ?? _background,
        checkColorActive: checkColorActive ?? _checkColorActive,
      );

  String get txtColorTitle => _txtColorTitle;

  String get backArrowColor => _backArrowColor;

  String get checkboxColorActive => _checkboxColorActive;

  String get checkboxColorInactive => _checkboxColorInactive;

  String get txtCurrency => _txtCurrency;

  String get txtColorAmountShort => _txtColorAmountShort;

  String get txtColorAmountFull => _txtColorAmountFull;

  String get icEqual => _icEqual;

  String get background => _background;

  String get checkColorActive => _checkColorActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['txt_color_title'] = _txtColorTitle;
    map['back_arrow_color'] = _backArrowColor;
    map['check_color'] = _checkColorActive;
    map['checkbox_color_active'] = _checkboxColorActive;
    map['checkbox_color_inactive'] = _checkboxColorInactive;
    map['txt_currency'] = _txtCurrency;
    map['txt_color_amount_short'] = _txtColorAmountShort;
    map['txt_color_amount_full'] = _txtColorAmountFull;
    map['ic_equal'] = _icEqual;
    map['background'] = _background;
    return map;
  }
}
