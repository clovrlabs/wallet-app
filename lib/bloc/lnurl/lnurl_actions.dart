import 'package:clovrlabs_wallet/bloc/async_action.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_model.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_model.dart';
import 'package:fixnum/fixnum.dart';

class Fetch extends AsyncAction {
  final String lnurl;

  Fetch(this.lnurl);
}

class Withdraw extends AsyncAction {
  final String bolt11Invoice;

  Withdraw(this.bolt11Invoice);
}

class OpenChannel extends AsyncAction {
  final String uri;
  final String callback;
  final String k1;

  OpenChannel(this.uri, this.callback, this.k1);
}

class Login extends AsyncAction {
  final AuthFetchResponse response;
  final bool jwt;

  Login(this.response, {this.jwt = false});
}

class FetchInvoice extends AsyncAction {
  final PayFetchResponse response;

  FetchInvoice(this.response);
}
