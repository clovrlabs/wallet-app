import 'dart:developer';

import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/add_funds_bloc.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/bloc.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_actions.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/l10n/locales.dart';
import 'package:clovrlabs_wallet/routes/fiat_currencies/fiat_currency_settings.dart';
import 'package:clovrlabs_wallet/routes/payment_options/payment_options_page.dart';
import 'package:clovrlabs_wallet/services/remote_configs/remote_config_service.dart';
import 'package:clovrlabs_wallet/utils/theme.dart';
import 'package:clovrlabs_wallet/routes/qr_scan.dart';
import 'package:clovrlabs_wallet/utils/locale.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:clovrlabs_wallet/widgets/static_loader.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import 'app/locator.dart';
import 'bloc/lnurl/lnurl_bloc.dart';
import 'bloc/lsp/lsp_bloc.dart';
import 'bloc/reverse_swap/reverse_swap_bloc.dart';
import 'home_page.dart';
import 'main.dart';
import 'routes/add_funds/deposit_to_btc_address_page.dart';
import 'routes/add_funds/moonpay_webview.dart';
import 'routes/charge/items/item_page.dart';
import 'routes/connect_to_pay/connect_to_pay_page.dart';
import 'routes/create_invoice/create_invoice_page.dart';
import 'routes/dev/dev.dart';
import 'routes/get_refund/get_refund_page.dart';
import 'routes/initial_walkthrough.dart';
import 'routes/lsp/select_lsp_page.dart';
import 'routes/network/network.dart';
import 'routes/order_card/order_card_page.dart';
import 'routes/security_pin/lock_screen.dart';
import 'routes/security_pin/security_pin_page.dart';
import 'routes/settings/pos_settings_page.dart';
import 'routes/splash_page.dart';
import 'routes/transactions/pos_transactions_page.dart';
import 'routes/withdraw_funds/reverse_swap_page.dart';
import 'routes/withdraw_funds/unexpected_funds.dart';
import 'theme_data.dart' as theme;

final routeObserver = RouteObserver();
GetIt locator = GetIt.instance;

class WalletManager extends StatelessWidget {
  var _navigatorKey = GlobalKey<NavigatorState>();
  var _homeNavigatorKey = GlobalKey<NavigatorState>();
  RemoteConfigService _remoteService;
  
  WalletManager() {
    _remoteService = RemoteConfigService();
  }

  
  @override
  Widget build(BuildContext context) {
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var connectPayBloc = AppBlocsProvider.of<ConnectPayBloc>(context);
    var lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    var reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    var lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
    var posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    return FutureBuilder<FirebaseRemoteConfig>(
      future: _remoteService.setupRemoteConfig(),
      builder: (BuildContext context,
          AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
        if(snapshot.hasData) { return
          StreamBuilder(
      stream: userProfileBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return StaticLoader();
        }
        ClovrUserModel user = snapshot.data;
        theme.themeId = user.themeId;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.grey,
        ));
        return BlocProvider(
                creator: () =>
                    AddFundsBloc(
                      userProfileBloc.userStream,
                      accountBloc.accountStream,
                      lspBloc.lspStatusStream,
                    ),
                builder: (ctx) =>
                    MaterialApp(
                      color: Colors.white30,
                      navigatorKey: _navigatorKey,
                      title: getSystemAppLocalizations().app_name,
                      theme: theme.themeMap[user.themeId],
                      localizationsDelegates: localizationsDelegates(),
                      supportedLocales: AppLocalizations.supportedLocales,
                      builder: (BuildContext context, Widget child) {
                        final MediaQueryData data = MediaQuery.of(context);
                        return MediaQuery(
                          data: data.copyWith(
                            textScaleFactor: (data.textScaleFactor >= 1.3)
                                ? 1.3
                                : data.textScaleFactor,
                          ),
                          child: child,
                        );
                      },
                      initialRoute: user.registrationRequested
                          ? (user.locked ? '/lockscreen' : '/')
                          : '/splash',
                      // ignore: missing_return
                      onGenerateRoute: (RouteSettings settings) {
                        switch (settings.name) {
                          case '/intro':
                            return FadeInRoute(
                              builder: (_) =>
                                  InitialWalkthroughPage(
                                    userProfileBloc,
                                    backupBloc,
                                    posCatalogBloc,
                                  ),
                              settings: settings,
                            );
                          case '/splash':
                            return FadeInRoute(
                              builder: (_) => SplashPage(user),
                              settings: settings,
                            );
                          case '/lockscreen':
                            return NoTransitionRoute(
                              builder: (ctx) =>
                                  AppLockScreen(
                                        (pinEntered) {
                                      var validateAction = ValidatePinCode(
                                          pinEntered);
                                      userProfileBloc.userActionsSink.add(
                                          validateAction);
                                      return validateAction.future.then((_) {
                                        Navigator.pop(ctx);
                                        userProfileBloc.userActionsSink
                                            .add(SetLockState(false));
                                      });
                                    },
                                    onFingerprintEntered:
                                    user.securityModel.isFingerprintEnabled
                                        ? (isValid) async {
                                      if (isValid) {
                                        await Future.delayed(
                                          Duration(milliseconds: 200),
                                        );
                                        Navigator.pop(ctx);
                                        userProfileBloc.userActionsSink
                                            .add(SetLockState(false));
                                      }
                                    }
                                        : null,
                                    userProfileBloc: userProfileBloc,
                                  ),
                              settings: settings,
                            );
                          case '/':
                            return FadeInRoute(
                              builder: (_) =>
                                  WillPopScope(
                                    onWillPop: () async {
                                      return;
                                    },
                                    child: Navigator(
                                      key: _homeNavigatorKey,
                                      observers: [routeObserver],
                                      initialRoute: '/',
                                      // ignore: missing_return
                                      onGenerateRoute: (
                                          RouteSettings settings) {
                                        switch (settings.name) {
                                          case '/':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  Home(
                                                    accountBloc,
                                                    invoiceBloc,
                                                    userProfileBloc,
                                                    connectPayBloc,
                                                    backupBloc,
                                                    lspBloc,
                                                    reverseSwapBloc,
                                                    lnurlBloc,
                                                  ),
                                              settings: settings,
                                            );
                                          case '/order_card':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  OrderCardPage(
                                                    showSkip: false,
                                                  ),
                                              settings: settings,
                                            );
                                          case '/order_card?skip=true':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  OrderCardPage(
                                                    showSkip: true,
                                                  ),
                                              settings: settings,
                                            );
                                          case '/deposit_btc_address':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  DepositToBTCAddressPage(),
                                              settings: settings,
                                            );
                                          case '/buy_bitcoin':
                                            return FadeInRoute(
                                              builder: (_) => MoonpayWebView(),
                                              settings: settings,
                                            );
                                          case '/withdraw_funds':
                                            return FadeInRoute(
                                              builder: (_) => ReverseSwapPage(),
                                              settings: settings,
                                            );
                                          case '/send_coins':
                                            return MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    UnexpectedFunds(),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/select_lsp':
                                            return MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (_) =>
                                                  SelectLSPPage(
                                                    lstBloc: lspBloc,
                                                  ),
                                              settings: settings,
                                            );
                                          case '/get_refund':
                                            return FadeInRoute(
                                              builder: (_) => GetRefundPage(),
                                              settings: settings,
                                            );
                                          case '/create_invoice':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    CreateInvoicePage(),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/fiat_currency':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    FiatCurrencySettings(
                                                      accountBloc,
                                                      userProfileBloc,
                                                    ),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/network':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    NetworkPage(),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/security':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    SecurityPage(
                                                      userProfileBloc,
                                                      backupBloc,
                                                    ),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/payment_options':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    PaymentOptionsPage(),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/developers':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    DevView(),
                                                  ),
                                              settings: settings,
                                            );
                                          case '/connect_to_pay':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  withClovrLabsWalletTheme(
                                                    context,
                                                    ConnectToPayPage(null),
                                                  ),
                                              settings: settings,
                                            );

                                        // POS routes
                                          case '/add_item':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  ItemPage(posCatalogBloc),
                                              settings: settings,
                                            );
                                          case '/transactions':
                                            return FadeInRoute(
                                              builder: (_) =>
                                                  PosTransactionsPage(),
                                              settings: settings,
                                            );
                                          case '/settings':
                                            return FadeInRoute(
                                              builder: (_) => PosSettingsPage(),
                                              settings: settings,
                                            );
                                          case '/qr_scan':
                                            return MaterialPageRoute<String>(
                                              fullscreenDialog: true,
                                              builder: (_) => QRScan(),
                                              settings: settings,
                                            );
                                        }
                                        assert(false);
                                      },
                                    ),
                                  ),
                              settings: settings,
                            );
                        }
                        assert(false);
                      },
                    ),
              );

          },
        );
        }else{
          return  Container();
        }
      },
    );
  }
}
