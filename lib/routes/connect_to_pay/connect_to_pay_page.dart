import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:clovrlabs_wallet/bloc/connect_pay/connect_pay_model.dart';
import 'package:clovrlabs_wallet/bloc/connect_pay/payer_session.dart';
import 'package:clovrlabs_wallet/bloc/lsp/lsp_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lsp/lsp_model.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:clovrlabs_wallet/widgets/flushbar.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'payee_session_widget.dart';
import 'payer_session_widget.dart';

class ConnectToPayPage extends StatefulWidget {
  final RemoteSession _currentSession;

  const ConnectToPayPage(
    this._currentSession,
  );

  @override
  State<StatefulWidget> createState() {
    return ConnectToPayPageState(_currentSession);
  }
}

class ConnectToPayPageState extends State<ConnectToPayPage> {
  final _key = GlobalKey<ScaffoldState>();
  bool _payer;
  String _remoteUserName;
  String _title = "";
  StreamSubscription _errorsSubscription;
  StreamSubscription _remotePartyErrorSubscription;
  StreamSubscription _endOfSessionSubscription;
  RemoteSession _currentSession;
  Object _error;
  bool _destroySessionOnTerminate = true;
  bool _isInit = false;

  ConnectToPayPageState(
    this._currentSession,
  );

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final texts = AppLocalizations.of(context);
      final ctpBloc = AppBlocsProvider.of<ConnectPayBloc>(context);

      try {
        if (_currentSession == null) {
          _currentSession = ctpBloc.createPayerRemoteSession();
          ctpBloc.startSession(_currentSession);
        }
        _payer = _currentSession.runtimeType == PayerRemoteSession;
        _title = _payer
            ? texts.connect_to_pay_title_payer
            : texts.connect_to_pay_title_payee;
        registerErrorsListener();
        registerEndOfSessionListener(context);
        _isInit = true;
      } catch (error) {
        _error = error;
      }
    }
    super.didChangeDependencies();
  }

  void registerErrorsListener() async {
    _errorsSubscription = _currentSession.sessionErrors.listen((error) {
      _popWithMessage(error.description);
    });

    _remotePartyErrorSubscription =
        _currentSession.paymentSessionStateStream.listen((s) {
      final error = !_payer ? s.payerData?.error : s.payeeData?.error;
      if (error != null) {
        _popWithMessage(error);
      }
    });
  }

  void registerEndOfSessionListener(BuildContext context) async {
    final texts = AppLocalizations.of(context);
    _endOfSessionSubscription =
        _currentSession.paymentSessionStateStream.listen(
      (session) {
        if (_remoteUserName == null) {
          _remoteUserName = _payer
              ? session.payeeData?.userName
              : session.payerData?.userName;
        }

        if (session.remotePartyCancelled) {
          _popWithMessage(
            _remoteUserName != null
                ? texts.connect_to_pay_canceled_remote_user(_remoteUserName)
                : _payer
                    ? texts.connect_to_pay_canceled_payee
                    : texts.connect_to_pay_canceled_payer,
          );
          return;
        }

        if (session.paymentFulfilled) {
          final formattedAmount = _currentSession.currentUser.currency
              .format(Int64(session.settledAmount));
          _popWithMessage(
            _payer
                ? texts.connect_to_pay_success_payer(
                    _remoteUserName,
                    formattedAmount,
                  )
                : texts.connect_to_pay_success_payee(
                    _remoteUserName,
                    formattedAmount,
                  ),
            destroySession: _payer,
          );
        }
      },
      onDone: () => _popWithMessage(
        null,
        destroySession: false,
      ),
    );
  }

  void _popWithMessage(message, {destroySession = true}) {
    _destroySessionOnTerminate = destroySession;
    Navigator.pop(_key.currentContext);
    if (message != null) {
      showFlushbar(
        _key.currentContext,
        message: message,
      );
    }
  }

  Future _clearSession() async {
    _remoteUserName = null;
    await _endOfSessionSubscription.cancel();
    await _errorsSubscription.cancel();
    await _remotePartyErrorSubscription.cancel();
  }

  @override
  void dispose() {
    if (_currentSession != null) {
      _currentSession.terminate(
        permanent: _destroySessionOnTerminate,
      );
      _clearSession();
    }
    super.dispose();
  }

  void _onTerminateSession(BuildContext context) async {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    bool cancel = await promptAreYouSure(
      _key.currentContext,
      null,
      Text(
        texts.connect_to_pay_exit_warning,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      textStyle: themeData.dialogTheme.contentTextStyle,
    );
    if (cancel) {
      _popWithMessage(null);
    }
  }

  void _onBackPressed() async {
    _popWithMessage(
      null,
      destroySession: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        actions: _error == null
            ? [
                IconButton(
                  onPressed: () => _onTerminateSession(context),
                  icon: Icon(
                    Icons.close,
                    color: themeData.iconTheme.color,
                  ),
                ),
              ]
            : null,
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(
          onPressed: _onBackPressed,
        ),
        title: Text(
          _title,
          // style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (_error != null) {
      return SessionErrorWidget(_error);
    }

    if (_currentSession == null) {
      return Center(child: Loader());
    }

    if (_currentSession == null) {
      return Container();
    }

    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return StreamBuilder<PaymentSessionState>(
      stream: _currentSession.paymentSessionStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(child: Loader());
        }

        return StreamBuilder<LSPStatus>(
          stream: lspBloc.lspStatusStream,
          builder: (context, lspSnapshot) {
            return StreamBuilder(
              stream: accountBloc.accountStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Loader());
                }
                if (_currentSession.runtimeType == PayerRemoteSession) {
                  return PayerSessionWidget(
                    _currentSession,
                    snapshot.data,
                  );
                } else {
                  return PayeeSessionWidget(
                    _currentSession,
                    snapshot.data,
                    lspSnapshot.data,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}

class SessionErrorWidget extends StatelessWidget {
  final Object _error;

  const SessionErrorWidget(this._error);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        heightFactor: 0.0,
        child: Text(
          texts.connect_to_pay_failed_to_connect(_error.toString()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
