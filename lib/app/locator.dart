import 'package:get_it/get_it.dart';

import '../widgets/styles/app_color_scheme.dart';

GetIt locator = GetIt.instance;

Future<void> setupColorScheme(String mainScreen, String drawerScreen, String currencyScreen) async {

  locator.allowReassignment=true;

  locator.registerFactory(() => AppConfigScheme(mainScreen, drawerScreen, currencyScreen));
}
