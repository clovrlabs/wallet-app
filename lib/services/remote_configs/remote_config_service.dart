import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import '../../app/locator.dart';

class RemoteConfigService {
  final StreamController<dynamic> _fetchingError =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get fetchingErrorStream => _fetchingError.stream;

  StreamController<dynamic> get fetchingErrorController => _fetchingError;

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.ensureInitialized();
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 0),
      minimumFetchInterval: const Duration(minutes: 0),
    ));
    // await remoteConfig.setDefaults(<String, String>{
    //   'welcome': 'default welcome',
    //   'hello': 'default hello',
    // })
    await _remoteConfig.fetchAndActivate();
    await setupColorScheme(
      _remoteConfig.getString("main_screen"),
      _remoteConfig.getString("drawer_screen"),
      _remoteConfig.getString("fiat_currency"),
    );
    // await print(_remoteConfig.getString("main_screen"));
//    await _remoteConfig.fetchAndActivate();
    // RemoteConfigValue([1], ValueSource.valueStatic);_
    return _remoteConfig;
  }

  Future<void> onForceFetched(FirebaseRemoteConfig remoteConfig) async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero));
      await remoteConfig.fetchAndActivate();
    } on PlatformException catch (exception) {
      fetchingErrorController.add(exception.message);
    } catch (exception) {
      fetchingErrorController.add(exception.toString());
    }
  }
}
