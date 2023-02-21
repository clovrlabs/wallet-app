import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class StaticLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();

      // Container(
      //   width: 0.0,
      //   height: 0.0,
      //   decoration: BoxDecoration(color: Color.fromRGBO(94, 94, 94, 1.0)));
  }


  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await  remoteConfig.fetchAndActivate();
//    RemoteConfigValue(null, ValueSource.valueStatic);
    print(remoteConfig.getString("main_screen"));
    return remoteConfig;
  }
}
