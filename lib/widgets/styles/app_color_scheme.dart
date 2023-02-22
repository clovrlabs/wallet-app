import 'dart:convert';

import 'drawer_screen_remote_confs.dart';
import 'main_screen_colors.dart';

class AppColorScheme {
  MainScreenRemoteConfs _mainScreenRemoteConfigs;
  DrawerRemoteConfs _drawerItemConfig;

  MainScreenRemoteConfs get mainScreenRemoteConfigs => _mainScreenRemoteConfigs;

  DrawerRemoteConfs get drawerItemConfig => _drawerItemConfig;

  AppColorScheme(String mainScreenConfs, String drawerItemConfig) {
    _mainScreenRemoteConfigs = MainScreenRemoteConfs.fromJson(
      json.decode(mainScreenConfs),
    );
    _drawerItemConfig = DrawerRemoteConfs.fromJson(
      json.decode(drawerItemConfig),
    );
  }
}
