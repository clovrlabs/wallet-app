import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
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
    await _remoteConfig.fetchAndActivate();
    await setupColorScheme(
      _remoteConfig.getString("main_screen"),
      _remoteConfig.getString("drawer_screen"),
      _remoteConfig.getString("fiat_currency_screen"),
      _remoteConfig.getString("backup_security_screen"),
      _remoteConfig.getString("network_screen"),
      _remoteConfig.getString("lightning_fees_screen"),
      _remoteConfig.getString("developer_screen"),
    );
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
