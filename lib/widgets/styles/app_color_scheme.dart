import 'dart:convert';

import 'drawer_screen_remote_confs.dart';
import 'fiat_currency_remote_confs.dart';
import 'main_screen_colors.dart';

class AppConfigScheme {
  MainScreenRemoteConfs _mainScreenRemoteConfigs;
  DrawerRemoteConfs _drawerItemConfig;
  FiatCurrencyRemoteConfs _fiatCurrencyRemoteConfs;

  MainScreenRemoteConfs get mainScreenRemoteConfigs => _mainScreenRemoteConfigs;

  DrawerRemoteConfs get drawerItemConfig => _drawerItemConfig;

  FiatCurrencyRemoteConfs get fiatCurrencyRemoteConfs =>
      _fiatCurrencyRemoteConfs;

  AppConfigScheme(
    String mainScreenConfs,
    String drawerItemConfig,
    String fiatCurrencyRemoteConfs,
  ) {
    _mainScreenRemoteConfigs = MainScreenRemoteConfs.fromJson(
      json.decode(mainScreenConfs),
    );
    _drawerItemConfig = DrawerRemoteConfs.fromJson(
      json.decode(drawerItemConfig),
    );
    _fiatCurrencyRemoteConfs = FiatCurrencyRemoteConfs.fromJson(
      json.decode(fiatCurrencyRemoteConfs),
    );
  }
}
