import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MakeInvoiceRequest extends StatelessWidget {
  final AccountModel account;
  final int amount;
  final String description;

  const MakeInvoiceRequest({
    Key key,
    this.amount,
    this.description,
    this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    List<Widget> children = [
      Text(
        texts.make_invoice_request_title,
        style: themeData.primaryTextTheme.headline3.copyWith(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        account.currency.format(Int64(amount)),
        style: themeData.primaryTextTheme.headline5,
        textAlign: TextAlign.center,
      )
    ];

    if (description != null && description.isEmpty) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
        child: AutoSizeText(
          description,
          style: themeData.primaryTextTheme.headline3.copyWith(
            fontSize: 16,
          ),
          textAlign:
              description.length > 40 ? TextAlign.justify : TextAlign.center,
          maxLines: 3,
        ),
      ));
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              texts.make_invoice_request_action_cancel,
              style: themeData.primaryTextTheme.button,
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              texts.make_invoice_request_action_approve,
              style: themeData.primaryTextTheme.button,
            ),
          ),
        ],
      ),
    ));

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(
          minHeight: 220.0,
          maxHeight: 350.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
