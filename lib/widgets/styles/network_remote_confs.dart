class NetworkRemoteConfs {
  String txtColorTitle;
  String backArrowColor;
  String txtHintNode;
  String txtNode;
  String txtHintOptionalNode;
  String btTxtResetColor;
  String btBgResetColor;
  String btTxtSaveColor;
  String btBgSaveColor;
  String bgColor;
  String btOutlineSaveColor;
  String btOutlineResetColor;

  NetworkRemoteConfs({
    this.txtColorTitle,
    this.backArrowColor,
    this.txtHintNode,
    this.txtNode,
    this.txtHintOptionalNode,
    this.btTxtResetColor,
    this.btBgResetColor,
    this.btTxtSaveColor,
    this.btBgSaveColor,
    this.bgColor,
    this.btOutlineSaveColor,
    this.btOutlineResetColor,
  });

  NetworkRemoteConfs.fromJson(dynamic json) {
    txtColorTitle = json['txt_color_title'];
    backArrowColor = json['back_arrow_color'];
    txtHintNode = json['txt_hint_node'];
    txtNode = json['txt_node'];
    txtHintOptionalNode = json['txt_hint_optional_node'];
    btTxtResetColor = json['bt_txt_reset_color'];
    btBgResetColor = json['bt_bg_reset_color'];
    btTxtSaveColor = json['bt_txt_save_color'];
    btBgSaveColor = json['bt_bg_save_color'];
    bgColor = json['bg_color'];
    btOutlineSaveColor = json['bt_outline_save_color'];
    btOutlineResetColor = json['bt_outline_reset_color'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['txt_color_title'] = txtColorTitle;
    map['back_arrow_color'] = backArrowColor;
    map['txt_hint_node'] = txtHintNode;
    map['txt_node'] = txtNode;
    map['txt_hint_optional_node'] = txtHintOptionalNode;
    map['bt_txt_reset_color'] = btTxtResetColor;
    map['bt_bg_reset_color'] = btBgResetColor;
    map['bt_txt_save_color'] = btTxtSaveColor;
    map['bt_bg_save_color'] = btBgSaveColor;
    map['bg_color'] = bgColor;
    map['bt_outline_save_color'] = btOutlineSaveColor;
    map['bt_outline_reset_color'] = btOutlineResetColor;
    return map;
  }
}
