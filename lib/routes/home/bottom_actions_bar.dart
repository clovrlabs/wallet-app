import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/account/add_fund_vendor_model.dart';
import 'package:clovrlabs_wallet/bloc/account/add_funds_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_model.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lsp/lsp_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lsp/lsp_model.dart';
import 'package:clovrlabs_wallet/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/colors_ext.dart';
import 'package:clovrlabs_wallet/widgets/enter_payment_info_dialog.dart';
import 'package:clovrlabs_wallet/widgets/escher_dialog.dart';
import 'package:clovrlabs_wallet/widgets/lsp_fee.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:clovrlabs_wallet/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/locator.dart';
import '../../widgets/styles/app_color_scheme.dart';

class BottomActionsBar extends StatelessWidget {
  final AccountModel account;
  final GlobalKey firstPaymentItemKey;
  final colorScheme = locator.get<AppConfigScheme>().mainScreenRemoteConfigs;
  BottomActionsBar(this.account, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    AutoSizeGroup actionsGroup = AutoSizeGroup();

    return BottomAppBar(

      child: Container(
        height: 60,
        color: colorScheme.colorBottomTab.toColor(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _Action(
              onPress: () => _showSendOptions(context),
              group: actionsGroup,
              text: texts.bottom_action_bar_send,
              textColor: colorScheme.txtColorBottomTabSend.toColor(),
              iconAssetPath: "src/icon/send-action.png",
            ),
            Container(
              width: 64,
            ),
            _Action(
              onPress: () => showReceiveOptions(context, account),
              group: actionsGroup,
              text: texts.bottom_action_bar_receive,
              textColor: colorScheme.txtColorBottomTabRecieve.toColor(),
              iconAssetPath: "src/icon/receive-action.png",

            ),
          ],
        ),
      ),
    );
  }

  Future _showSendOptions(BuildContext context) async {
    final texts = AppLocalizations.of(context);
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
    LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    await showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StreamBuilder<Future<DecodedClipboardData>>(
              stream: invoiceBloc.decodedClipboardStream,
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    ListTile(
                      enabled: account.connected,
                      leading: _ActionImage(
                          iconAssetPath: "src/icon/paste.png",
                          enabled: account.connected),
                      title: Text(
                        texts.bottom_action_bar_paste_invoice,
                        style: theme.bottomSheetTextStyle,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        DecodedClipboardData clipboardData =
                            await snapshot.data;
                        if (clipboardData != null) {
                          if (clipboardData.type == "lnurl" ||
                              clipboardData.type == "lightning-address") {
                            lnurlBloc.lnurlInputSink.add(clipboardData.data);
                          } else if (clipboardData.type == "invoice") {
                            invoiceBloc.decodeInvoiceSink
                                .add(clipboardData.data);
                          } else if (clipboardData.type == "nodeID") {
                            Navigator.of(context).push(FadeInRoute(
                              builder: (_) => SpontaneousPaymentPage(
                                  clipboardData.data, firstPaymentItemKey),
                            ));
                          }
                        } else {
                          return showDialog(
                              useRootNavigator: false,
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => EnterPaymentInfoDialog(context,
                                  invoiceBloc, lnurlBloc, firstPaymentItemKey));
                        }
                      },
                    ),
                    // Divider(
                    //   height: 0.0,
                    //   color: Colors.white.withOpacity(0.2),
                    //   indent: 72.0,
                    // ),
                    // ListTile(
                    //     enabled: account.connected,
                    //     leading: _ActionImage(
                    //         iconAssetPath: "src/icon/connect_to_pay.png",
                    //         enabled: account.connected),
                    //     title: Text(
                    //       texts.bottom_action_bar_connect_to_pay,
                    //       style: theme.bottomSheetTextStyle,
                    //     ),
                    //     onTap: () {
                    //       Navigator.of(context).pop();
                    //       Navigator.of(context).pushNamed("/connect_to_pay");
                    //     }),
                    Divider(
                      height: 0.0,
                      color: Colors.white.withOpacity(0.2),
                      indent: 72.0,
                    ),
                    ListTile(
                        enabled: account.connected,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/bitcoin.png",
                            enabled: account.connected),
                        title: Text(
                          texts.bottom_action_bar_send_btc_address,
                          style: theme.bottomSheetTextStyle,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/withdraw_funds");
                        }),
                    StreamBuilder(
                        stream: accBloc.accountSettingsStream,
                        builder: (context, settingsSnapshot) {
                          if (!settingsSnapshot.hasData) {
                            return SizedBox();
                          }
                          AccountSettings settings = settingsSnapshot.data;
                          if (settings.isEscherEnabled) {
                            return Column(
                              children: [
                                Divider(
                                  height: 0.0,
                                  color: Colors.white.withOpacity(0.2),
                                  indent: 72.0,
                                ),
                                ListTile(
                                    enabled: account.connected,
                                    leading: _ActionImage(
                                        iconAssetPath: "src/icon/escher.png",
                                        enabled: account.connected),
                                    title: Text(
                                      texts.bottom_action_bar_escher,
                                      style: theme.bottomSheetTextStyle,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      return showDialog(
                                          useRootNavigator: false,
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) =>
                                              EscherDialog(context, accBloc));
                                    }),
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                    SizedBox(height: 8.0)
                  ],
                );
              });
        });
  }
}

class _Action extends StatelessWidget {
  final String text;
  final AutoSizeGroup group;
  final String iconAssetPath;
  final Function() onPress;
  final Alignment minimizedAlignment;
  final Color textColor;

  const _Action({
    Key key,
    this.text,
    this.group,
    this.iconAssetPath,
    this.onPress,
    this.textColor,
    this.minimizedAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: this.onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.bottomAppBarBtnStyle.copyWith(
            color: textColor,
              fontSize: 13.5 / MediaQuery.of(context).textScaleFactor),
          maxLines: 1,
        ),
      ),
    );
  }
}

class _ActionImage extends StatelessWidget {
  final String iconAssetPath;
  final bool enabled;

  const _ActionImage({Key key, this.iconAssetPath, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(iconAssetPath),
      color: enabled ? Colors.white : Theme.of(context).disabledColor,
      fit: BoxFit.contain,
      width: 24.0,
      height: 24.0,
    );
  }
}

Future showReceiveOptions(BuildContext parentContext, AccountModel account) {
  final texts = AppLocalizations.of(parentContext);
  AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(parentContext);
  LSPBloc lspBloc = AppBlocsProvider.of<LSPBloc>(parentContext);

  return showModalBottomSheet(
    context: parentContext,
    builder: (ctx) {
      return
        StreamBuilder<LSPStatus>(
          stream: lspBloc.lspStatusStream,
          builder: (context, lspSnapshot) {
            return StreamBuilder<List<AddFundVendorModel>>(
              stream: addFundsBloc.availableVendorsStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return SizedBox();
                }

                List<Widget> children =
                    snapshot.data.where((v) => v.isAllowed).map((v) {
                  return Column(
                    children: [
                      Divider(
                        height: 0.0,
                        color: Theme.of(context).dividerColor.withOpacity(0.2),
                        indent: 72.0,
                      ),
                      ListTile(
                          enabled: v.enabled &&
                              (account.connected || !v.requireActiveChannel),
                          leading: _ActionImage(
                              iconAssetPath: v.icon,
                              enabled:
                                  account.connected || !v.requireActiveChannel),
                          title: Text(
                            v.shortName ?? v.name,
                            style: theme.bottomSheetTextStyle,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            if (v.showLSPFee) {
                              promptLSPFeeAndNavigate(
                                parentContext,
                                account,
                                lspSnapshot.data.currentLSP,
                                v.route,
                              );
                            } else {
                              Navigator.of(context).pushNamed(v.route);
                            }
                          }),
                    ],
                  );
                }).toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    ListTile(
                        enabled: true,
                        leading: _ActionImage(
                          iconAssetPath: "src/icon/paste.png",
                          enabled: true,
                        ),
                        title: Text(
                          texts.bottom_action_bar_receive_invoice,
                          style: theme.bottomSheetTextStyle,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/create_invoice");
                        }),
                    ...children,
                    account.warningMaxChanReserveAmount == 0
                        ? SizedBox(height: 8.0)
                        : WarningBox(
                            boxPadding: EdgeInsets.all(16),
                            contentPadding: EdgeInsets.all(8),
                            child: AutoSizeText(
                              texts.bottom_action_bar_warning_balance_title(
                                account.currency.format(
                                  account.warningMaxChanReserveAmount,
                                  removeTrailingZeros: true,
                                ),
                              ),
                              maxFontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .fontSize,
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ],
                );
              },
            );
          },
      );
    },
  );
}
