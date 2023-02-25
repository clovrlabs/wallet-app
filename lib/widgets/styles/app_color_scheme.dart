import 'dart:convert';

import 'Network_remote_confs.dart';
import 'drawer_screen_remote_confs.dart';
import 'fiat_currency_remote_confs.dart';
import 'main_screen_colors.dart';

class AppConfigScheme {
  MainScreenRemoteConfs _mainScreenRemoteConfigs;
  DrawerRemoteConfs _drawerItemConfig;
  FiatCurrencyRemoteConfs _fiatCurrencyRemoteConfs;
  NetworkRemoteConfs _networkRemoteConfs;

  MainScreenRemoteConfs get mainScreenRemoteConfigs => _mainScreenRemoteConfigs;

  DrawerRemoteConfs get drawerItemConfig => _drawerItemConfig;

  FiatCurrencyRemoteConfs get fiatCurrencyRemoteConfs =>
      _fiatCurrencyRemoteConfs;

  NetworkRemoteConfs get networkRemoteConfs => _networkRemoteConfs;

  AppConfigScheme(
    String mainScreenConfs,
    String drawerItemConfig,
    String fiatCurrencyRemoteConfs,
    String networkRemoteConfs,
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
    _networkRemoteConfs = NetworkRemoteConfs.fromJson(
      json.decode(networkRemoteConfs),
    );
  }
}
