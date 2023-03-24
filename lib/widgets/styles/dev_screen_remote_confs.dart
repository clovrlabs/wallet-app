class DevScreenRemoteConfs {
  String _txtColorTitle;
  String _backArrowColor;
  String _colorContextMenu;
  String _bgColor;
  String _editTxtHint;
  String _editTxt;
  String _btExecuteColor;
  String _btCloseColor;
  String _txtItemColor;
  String _txtSubItemColor;
  String _arrowDropDownColor;
  String _txtErrorColor;

  DevScreenRemoteConfs({
    String txtColorTitle,
    String backArrowColor,
    String bgColor,
    String colorContextMenu,
    String editTxtHint,
    String editTxt,
    String btExecuteColor,
    String btCloseColor,
    String txtItemColor,
    String txtSubItemColor,
    String txtErrorColor,
    String arrowDropDownColor,
  }) {
    _txtColorTitle = txtColorTitle;
    _backArrowColor = backArrowColor;
    _bgColor = bgColor;
    _colorContextMenu = colorContextMenu;
    _editTxtHint = editTxtHint;
    _editTxt = editTxt;
    _btExecuteColor = btExecuteColor;
    _btCloseColor = btCloseColor;
    _txtItemColor = txtItemColor;
    _txtSubItemColor = txtSubItemColor;
    _txtErrorColor = txtErrorColor;
    _arrowDropDownColor = arrowDropDownColor;
  }

  DevScreenRemoteConfs.fromJson(dynamic json) {
    _txtColorTitle = json['txt_color_title'];
    _backArrowColor = json['back_arrow_color'];
    _colorContextMenu = json['color_context_menu'];
    _bgColor = json['background'];
    _editTxtHint = json['edit_txt_hint'];
    _editTxt = json['edit_txt'];
    _btExecuteColor = json['bt_execute_color'];
    _btCloseColor = json['bt_close_color'];
    _txtItemColor = json['txt_item_color'];
    _txtSubItemColor = json['txt_sub_item_color'];
    _txtErrorColor = json['edit_txt_error_color'];
    _arrowDropDownColor = json['arrow_drop_down_color'];
  }

  DevScreenRemoteConfs copyWith({
    String txtColorTitle,
    String backArrowColor,
    String bgColor,
    String colorContextMenu,
    String editTxtHint,
    String editTxt,
    String btExecuteColor,
    String btCloseColor,
    String txtItemColor,
    String txtSubItemColor,
    String arrowDropDownColor,
    String errorEditTextColor,
    String txtErrorColor,
  }) =>
      DevScreenRemoteConfs(
        txtColorTitle: txtColorTitle ?? _txtColorTitle,
        backArrowColor: backArrowColor ?? _backArrowColor,
        bgColor: bgColor ?? _bgColor,
        colorContextMenu: colorContextMenu ?? _colorContextMenu,
        editTxtHint: editTxtHint ?? _editTxtHint,
        editTxt: editTxt ?? _editTxt,
        btExecuteColor: btExecuteColor ?? _btExecuteColor,
        btCloseColor: btCloseColor ?? _btCloseColor,
        txtItemColor: txtItemColor ?? _txtItemColor,
        txtSubItemColor: txtSubItemColor ?? _txtSubItemColor,
        arrowDropDownColor: arrowDropDownColor ?? _arrowDropDownColor,
        txtErrorColor: txtErrorColor ?? _txtErrorColor,
      );

  String get txtColorTitle => _txtColorTitle;

  String get backArrowColor => _backArrowColor;

  String get colorContextMenu => _colorContextMenu;

  String get editTxtHint => _editTxtHint;

  String get editTxt => _editTxt;

  String get btExecuteColor => _btExecuteColor;

  String get btCloseColor => _btCloseColor;

  String get txtItemColor => _txtItemColor;

  String get txtSubItemColor => _txtSubItemColor;

  String get arrowDropDownColor => _arrowDropDownColor;

  String get bgColor => _bgColor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['txt_color_title'] = _txtColorTitle;
    map['back_arrow_color'] = _backArrowColor;
    map['background'] = _bgColor;
    map['color_context_menu'] = _colorContextMenu;
    map['edit_txt_hint'] = _editTxtHint;
    map['edit_txt'] = _editTxt;
    map['bt_execute_color'] = _btExecuteColor;
    map['bt_close_color'] = _btCloseColor;
    map['txt_item_color'] = _txtItemColor;
    map['txt_sub_item_color'] = _txtSubItemColor;
    map['edit_txt_error_color'] = _txtErrorColor;
    map['arrow_drop_down_color'] = _arrowDropDownColor;
    return map;
  }

  String get txtErrorColor => _txtErrorColor;

  set txtErrorColor(String value) {
    _txtErrorColor = value;
  }
}
