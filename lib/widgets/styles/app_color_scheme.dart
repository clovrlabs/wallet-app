import 'dart:convert';

import 'package:clovrlabs_wallet/widgets/styles/dev_screen_remote_confs.dart';
import 'package:clovrlabs_wallet/widgets/styles/security_backup_screen.dart';

import 'Network_remote_confs.dart';
import 'drawer_screen_remote_confs.dart';
import 'fiat_currency_remote_confs.dart';
import 'lightning_fees_confs.dart';
import 'main_screen_colors.dart';

class AppConfigScheme {
  MainScreenRemoteConfs _mainScreenRemoteConfigs;
  DrawerRemoteConfs _drawerItemConfig;
  FiatCurrencyRemoteConfs _fiatCurrencyRemoteConfs;
  SecurityBackupScreen _securityBackupScreen;
  DevScreenRemoteConfs _devScreenRemoteConfs;

  SecurityBackupScreen get securityBackupScreen => _securityBackupScreen;
  NetworkRemoteConfs _networkRemoteConfs;
  LightningFeesConfs _lightningFeesConfs;

  MainScreenRemoteConfs get mainScreenRemoteConfigs => _mainScreenRemoteConfigs;

  DrawerRemoteConfs get drawerItemConfig => _drawerItemConfig;

  FiatCurrencyRemoteConfs get fiatCurrencyRemoteConfs =>
      _fiatCurrencyRemoteConfs;

  NetworkRemoteConfs get networkRemoteConfs => _networkRemoteConfs;

  DevScreenRemoteConfs get devScreenRemoteConfs => _devScreenRemoteConfs;

  set devScreenRemoteConfs(DevScreenRemoteConfs value) {
    _devScreenRemoteConfs = value;
  }

  LightningFeesConfs get lightningFeesConfs => _lightningFeesConfs;

  AppConfigScheme(
    String mainScreenConfs,
    String drawerItemConfig,
    String fiatCurrencyRemoteConfs,
    String securityBackupScreen,
    String networkRemoteConfs,
    String lightningFeesScreen,
    String devRemoteConfs,
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
    _securityBackupScreen = SecurityBackupScreen.fromJson(
      json.decode(securityBackupScreen),
    );
    _devScreenRemoteConfs = DevScreenRemoteConfs.fromJson(
      json.decode(devRemoteConfs),
    );
    _lightningFeesConfs = LightningFeesConfs.fromJson(
      json.decode(lightningFeesScreen),
    );
  }
}
