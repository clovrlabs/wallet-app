import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class StaticLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.fetchAndActivate();
    print(remoteConfig.getString("main_screen"));
    return remoteConfig;
  }
}
