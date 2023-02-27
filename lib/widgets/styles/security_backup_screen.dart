
class SecurityBackupScreen {

  String _txtColorTitle;
  String _backArrowColor;
  String _txtCreatePinArrow;
  String _txtStoreBackup;
  String _txtEncryptCloudBackup;
  String _background;

  SecurityBackupScreen({
      String txtColorTitle, 
      String backArrowColor, 
      String txtCreatePinArrow, 
      String txtStoreBackup, 
      String txtEncryptCloudBackup, 
      String background,}){
    _txtColorTitle = txtColorTitle;
    _backArrowColor = backArrowColor;
    _txtCreatePinArrow = txtCreatePinArrow;
    _txtStoreBackup = txtStoreBackup;
    _txtEncryptCloudBackup = txtEncryptCloudBackup;
    _background = background;
}

  SecurityBackupScreen.fromJson(Map<String, dynamic> json) {
    _txtColorTitle = json['txt_color_title'];
    _backArrowColor = json['back_arrow_color'];
    _txtCreatePinArrow = json['txt_create_pin_arrow'];
    _txtStoreBackup = json['txt_store_backup'];
    _txtEncryptCloudBackup = json['txt_encrypt_cloud_backup'];
    _background = json['background'];
  }

SecurityBackupScreen copyWith({  String txtColorTitle,
  String backArrowColor,
  String txtCreatePinArrow,
  String txtStoreBackup,
  String txtEncryptCloudBackup,
  String background,
}) => SecurityBackupScreen(  txtColorTitle: txtColorTitle ?? _txtColorTitle,
  backArrowColor: backArrowColor ?? _backArrowColor,
  txtCreatePinArrow: txtCreatePinArrow ?? _txtCreatePinArrow,
  txtStoreBackup: txtStoreBackup ?? _txtStoreBackup,
  txtEncryptCloudBackup: txtEncryptCloudBackup ?? _txtEncryptCloudBackup,
  background: background ?? _background,
);
  String get txtColorTitle => _txtColorTitle;
  String get backArrowColor => _backArrowColor;
  String get txtCreatePinArrow => _txtCreatePinArrow;
  String get txtStoreBackupData => _txtStoreBackup;
  String get txtEncryptCloudBackup => _txtEncryptCloudBackup;
  String get background => _background;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['txt_color_title'] = _txtColorTitle;
    map['back_arrow_color'] = _backArrowColor;
    map['txt_create_pin_arrow'] = _txtCreatePinArrow;
    map['txt_store_backup'] = _txtStoreBackup;
    map['txt_encrypt_cloud_backup'] = _txtEncryptCloudBackup;
    map['background'] = _background;
    return map;
  }
}
