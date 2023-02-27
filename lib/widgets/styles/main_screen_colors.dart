import 'dart:convert';

MainScreenRemoteConfs mainScreenRemoteConfsFromJson(String str) =>
    MainScreenRemoteConfs.fromJson(json.decode(str));

String mainScreenRemoteConfsToJson(MainScreenRemoteConfs data) =>
    json.encode(data.toJson());

class MainScreenRemoteConfs {
  MainScreenRemoteConfs({
    this.backgroundColor,
    this.btLogo,
    this.syncSpinner,
    this.txtAmountColor,
    this.txtColorItemNameTransaction,
    this.txtColorItemFeeTransaction,
    this.txtColorItemDate,
    this.txtColorBottomTabSend,
    this.txtColorBottomTabRecieve,
    this.colorBottomTab,
    this.iconBottomTabPhoto,
    this.backgroundColorQR,
    this.iconBottomTabPhotoTint,
    this.txtCurrency,
    this.txtColorAmountTransaction,
  });

  String backgroundColor;
  String btLogo;
  String syncSpinner;
  String txtAmountColor;
  String txtColorItemNameTransaction;
  String txtColorItemFeeTransaction;
  String txtColorItemDate;
  String txtColorBottomTabSend;
  String txtColorBottomTabRecieve;
  String txtCurrency;
  String colorBottomTab;
  String iconBottomTabPhoto;
  String backgroundColorQR;
  String iconBottomTabPhotoTint;
  String txtColorAmountTransaction;

  factory MainScreenRemoteConfs.fromJson(Map<String, dynamic> json) =>
      MainScreenRemoteConfs(
        backgroundColor: json['background_color'],
        btLogo: json['bt_logo'],
        syncSpinner: json['sync_spinner'],
        txtAmountColor: json['txt_amount_color'],
        txtColorItemNameTransaction: json['txt_color_item_name_transaction'],
        txtColorItemFeeTransaction: json['txt_color_item_fee_transaction'],
        txtColorItemDate: json['txt_color_item_date'],
        txtColorBottomTabSend: json['txt_color_bottom_tab_send'],
        txtColorBottomTabRecieve: json['txt_color_bottom_tab_recieve'],
        colorBottomTab: json['color_bottom_tab'],
        iconBottomTabPhoto: json['icon_bottom_tab_photo'],
        backgroundColorQR: json['background_color_qr'],
        iconBottomTabPhotoTint: json['icon_bottom_tab_photo_tint'],
        txtCurrency: json['txt_currency'],
        txtColorAmountTransaction: json['txt_color_amount_transaction'],
      );

  Map<String, dynamic> toJson() => {
        'background_color': backgroundColor,
        'bt_logo': btLogo,
        'sync_spinner': syncSpinner,
        'txt_amount_color': txtAmountColor,
        'txt_color_item_name_transaction': txtColorItemNameTransaction,
        'txt_color_item_fee_transaction': txtColorItemFeeTransaction,
        'txt_color_item_date': txtColorItemDate,
        'txt_color_bottom_tab_send': txtColorBottomTabSend,
        'txt_color_bottom_tab_recieve': txtColorBottomTabRecieve,
        'color_bottom_tab': colorBottomTab,
        'icon_bottom_tab_photo': iconBottomTabPhoto,
        'background_color_qr': backgroundColorQR,
        'icon_bottom_tab_photo_tint': iconBottomTabPhotoTint,
        'txt_currency': txtCurrency,
        'txt_color_amount_transaction': txtColorAmountTransaction,
      };
}
