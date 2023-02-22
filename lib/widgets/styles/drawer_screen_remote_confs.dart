class DrawerRemoteConfs {
  String topBgColorDrawer;
  String icTopDrawerLabel;
  String bottomBgColorDrawer;
  String txtColorItem;
  String icLinkBalance;
  String icLinkPointSale;
  String icLinkPreferences;
  String icLinkFiatCurrencies;
  String icLinkNetwork;
  String icLinkSecurityBackup;
  String icLinkLightningFee;
  String icLinkDeveloper;
  String icColorArrow;
  String colorSelectedItem;
  String colorUnSelectedItem;
  String txtColorSelectedItem;
  String icColorSelectedItem;
  String icPosSettings;
  bool isPointOfSaleEnabled;
  bool isFiatCurrenciesEnabled;
  bool isNetworkEnabled;
  bool isSecurityBackupEnabled;
  bool isLightningFeesEnabled;
  bool isDevelopersEnabled;
  bool isSettingsEnabled;

  DrawerRemoteConfs({
    this.topBgColorDrawer,
    this.icTopDrawerLabel,
    this.bottomBgColorDrawer,
    this.txtColorItem,
    this.icLinkBalance,
    this.icLinkPointSale,
    this.icLinkPreferences,
    this.icLinkFiatCurrencies,
    this.icLinkNetwork,
    this.icLinkSecurityBackup,
    this.icLinkLightningFee,
    this.icLinkDeveloper,
    this.icColorArrow,
    this.colorSelectedItem,
    this.txtColorSelectedItem,
    this.colorUnSelectedItem,
    this.icColorSelectedItem,
    this.icPosSettings,
    this.isPointOfSaleEnabled,
    this.isFiatCurrenciesEnabled,
    this.isNetworkEnabled,
    this.isSecurityBackupEnabled,
    this.isLightningFeesEnabled,
    this.isDevelopersEnabled,
    this.isSettingsEnabled,
  });

  DrawerRemoteConfs.fromJson(Map<String, dynamic> json) {
    topBgColorDrawer = json['top_bg_color_drawer'];
    icTopDrawerLabel = json['ic_top_drawer_label'];
    bottomBgColorDrawer = json['bottom_bg_color_drawer'];
    txtColorItem = json['txt_color_item'];
    icLinkBalance = json['ic_link_balance'];
    icLinkPointSale = json['ic_link_point_sale'];
    icLinkPreferences = json['ic_link_preferences'];
    icLinkFiatCurrencies = json['ic_link_fiat_currencies'];
    icLinkNetwork = json['ic_link_network'];
    icLinkSecurityBackup = json['ic_link_security_backup'];
    icLinkLightningFee = json['ic_link_lightning_fee'];
    icLinkDeveloper = json['ic_link_developer'];
    icColorArrow = json['ic_color_arrow'];
    colorSelectedItem = json['color_selected_item'];
    txtColorSelectedItem = json['txt_color_selected_item'];
    icColorSelectedItem = json['ic_color_selected_item'];
    colorUnSelectedItem = json['color_un_selected_item'];
    icPosSettings = json['ic_pos_settings'];
    isPointOfSaleEnabled = json['point_of_sale_enabled'];
    isFiatCurrenciesEnabled = json['fiat_currencies_enabled'];
    isNetworkEnabled = json['network_enabled'];
    isSecurityBackupEnabled = json['security_backup_enabled'];
    isLightningFeesEnabled = json['lightning_fees_enabled'];
    isDevelopersEnabled = json['developers_enabled'];
    isSettingsEnabled = json['settings_enabled'];
  }

  Map<String, dynamic> toJson() => {
        'top_bg_color_drawer': topBgColorDrawer,
        'ic_top_drawer_label': icTopDrawerLabel,
        'bottom_bg_color_drawer': bottomBgColorDrawer,
        'txt_color_item': txtColorItem,
        'ic_link_balance': icLinkBalance,
        'ic_link_point_sale': icLinkPointSale,
        'ic_link_preferences': icLinkPreferences,
        'ic_link_fiat_currencies': icLinkFiatCurrencies,
        'ic_link_network': icLinkNetwork,
        'ic_link_security_backup': icLinkSecurityBackup,
        'ic_link_lightning_fee': icLinkLightningFee,
        'ic_link_developer': icLinkDeveloper,
        'ic_color_arrow': icColorArrow,
        'color_selected_item': colorSelectedItem,
        'txt_color_selected_item': txtColorSelectedItem,
        'ic_color_selected_item': icColorSelectedItem,
        'color_un_selected_item': colorUnSelectedItem,
        'ic_pos_settings': icPosSettings,
        'point_of_sale_enabled': isPointOfSaleEnabled,
        'fiat_currencies_enabled': isFiatCurrenciesEnabled,
        'network_enabled': isNetworkEnabled,
        'security_backup_enabled': isSecurityBackupEnabled,
        'lightning_fees_enabled': isLightningFeesEnabled,
        'developers_enabled': isDevelopersEnabled,
        'settings_enabled': isSettingsEnabled,
      };
}
