import 'dart:math';

import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_actions.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/services/currency_data.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/colors_ext.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/flushbar.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/styles/fiat_currency_remote_confs.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/locator.dart';
import '../../widgets/styles/app_color_scheme.dart';

const double ITEM_HEIGHT = 72.0;

class FiatCurrencySettings extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfileBloc;

  FiatCurrencySettings(
    this.accountBloc,
    this.userProfileBloc,
  );

  @override
  FiatCurrencySettingsState createState() {
    return FiatCurrencySettingsState();
  }
}

class FiatCurrencySettingsState extends State<FiatCurrencySettings> {
  final _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return StreamBuilder<AccountModel>(
      stream: widget.accountBloc.accountStream.distinct((acc1, acc2) {
        return listEquals(acc1.preferredCurrencies, acc2.preferredCurrencies);
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        final account = snapshot.data;
        final remoteConfigs =
            locator.get<AppConfigScheme>().fiatCurrencyRemoteConfs;

        return Scaffold(
          appBar: AppBar(
            iconTheme: themeData.appBarTheme.iconTheme,
            textTheme: themeData.appBarTheme.textTheme,
            backgroundColor: remoteConfigs.background.toColor(),
            leading: backBtn.BackButton(
              color: remoteConfigs.backArrowColor.toColor(),
            ),
            title: Text(
              texts.fiat_currencies_title,
              style: TextStyle(
                color: remoteConfigs.txtColorTitle.toColor(),
              ),
            ),
            elevation: 0.0,
          ),
          body: DragAndDropLists(
            listPadding: EdgeInsets.zero,
            children: [
              _buildList(context, account, remoteConfigs),
            ],
            lastListTargetSize: 0,
            lastItemTargetHeight: 8,
            scrollController: _scrollController,
            onListReorder: (oldListIndex, newListIndex) => null,
            onItemReorder: (from, oldListIndex, to, newListIndex) =>
                _onReorder(context, account, from, to),
            itemDragHandle: DragHandle(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.drag_handle,
                  color: remoteConfigs.icEqual.toColor(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DragAndDropList _buildList(
    BuildContext context,
    AccountModel account,
    FiatCurrencyRemoteConfs remoteConfigs,
  ) {
    return DragAndDropList(
      header: SizedBox(),
      canDrag: false,
      children: List.generate(account.fiatConversionList.length, (index) {
        return DragAndDropItem(
          child: _buildFiatCurrencyTile(context, account, index, remoteConfigs),
          canDrag: account.preferredCurrencies.contains(
            account.fiatConversionList[index].currencyData.shortName,
          ),
        );
      }),
    );
  }

  void _changeFiatCurrency(
    AccountModel account,
    List<String> preferredFiatCurrencies,
  ) {
    for (var i = 0; i < preferredFiatCurrencies.length; i++) {
      if (isAboveMinAmount(account, i)) {
        widget.userProfileBloc.fiatConversionSink
            .add(preferredFiatCurrencies[i]);
        break;
      }
    }
    // revert to first item on list if no fiat value is above minimum amount
    widget.userProfileBloc.fiatConversionSink.add(preferredFiatCurrencies[0]);
    // reset pos currency to BTC if it's no longer in preferredFiatCurrencies
    if (!preferredFiatCurrencies.contains(account.posCurrencyShortName)) {
      widget.userProfileBloc.userActionsSink.add(SetPOSCurrency("BTC"));
    }
  }

  bool isAboveMinAmount(AccountModel accountModel, int index) {
    final conversions = accountModel.preferredFiatConversionList[index];
    final fiatValue = conversions.satToFiat(accountModel.balance);
    final fractionSize = conversions.currencyData.fractionSize;
    final minimumAmount = 1 / (pow(10, fractionSize));
    return fiatValue > minimumAmount;
  }

  Widget _buildFiatCurrencyTile(
    BuildContext context,
    AccountModel account,
    int index,
    FiatCurrencyRemoteConfs remoteConfigs,
  ) {
    final texts = AppLocalizations.of(context);

    final fiatConversion = account.fiatConversionList[index];
    final currencyData = fiatConversion.currencyData;
    final prefCurrencies = account.preferredCurrencies;

    return Theme(

      data: ThemeData(
        unselectedWidgetColor: remoteConfigs.checkboxColorInactive.toColor(),
        primaryColor: remoteConfigs.background.toColor(),
      ),
      child: CheckboxListTile(
          key: Key("tile-index-$index"),
          checkColor: remoteConfigs.background.toColor(),  // for the actual check mark
          activeColor: remoteConfigs.checkboxColorActive.toColor(),
          controlAffinity: ListTileControlAffinity.leading,
       tileColor: remoteConfigs.background.toColor(),
      value: prefCurrencies.contains(currencyData.shortName),
      onChanged: (bool checked) {
        setState(() {
          if (checked) {
            prefCurrencies.add(currencyData.shortName);
            // center item in viewport
            if (_scrollController.offset >=
                (ITEM_HEIGHT * (prefCurrencies.length - 1))) {
              _scrollController.animateTo(
                ((2 * prefCurrencies.length - 1) * ITEM_HEIGHT -
                        _scrollController.position.viewportDimension) /
                    2,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 400),
              );
            }
          } else if (account.preferredFiatConversionList.length != 1) {
            prefCurrencies.remove(
              currencyData.shortName,
            );
          }
          _updatePreferredCurrencies(context, account, prefCurrencies);
        });
      },
      subtitle: Text(
        _subtitle(texts, currencyData),
        style: theme.fiatConversionDescriptionStyle.copyWith(
          color: remoteConfigs.txtColorAmountFull.toColor(),
        ),
      ),
      title: RichText(
        text: TextSpan(
          text: currencyData.shortName,
          style: theme.fiatConversionTitleStyle.copyWith(
            color: remoteConfigs.txtColorAmountShort.toColor(),
          ),
          children: [
            TextSpan(
              text: " (${currencyData.symbol})",
              style: theme.fiatConversionDescriptionStyle.copyWith(
                color: remoteConfigs.txtColorAmountShort.toColor(),
              ),
            ),
          ],
        ),
      )
    ),
    );
  }

  String _subtitle(AppLocalizations texts, CurrencyData currencyData) {
    final localizedName = currencyData.localizedName[texts.locale];
    return localizedName ?? currencyData.name;
  }

  void _onReorder(
    BuildContext context,
    AccountModel account,
    int oldIndex,
    int newIndex,
  ) {
    final preferredFiatCurrencies = List<String>.from(
      account.preferredCurrencies,
    );
    if (newIndex >= preferredFiatCurrencies.length) {
      newIndex = preferredFiatCurrencies.length - 1;
    }
    String item = preferredFiatCurrencies.removeAt(oldIndex);
    preferredFiatCurrencies.insert(newIndex, item);
    _updatePreferredCurrencies(context, account, preferredFiatCurrencies);
  }

  void _updatePreferredCurrencies(
    BuildContext context,
    AccountModel account,
    List<String> preferredFiatCurrencies,
  ) {
    final texts = AppLocalizations.of(context);
    var action = UpdatePreferredCurrencies(preferredFiatCurrencies);
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.then((_) {
      _changeFiatCurrency(account, preferredFiatCurrencies);
    }).catchError((err) {
      showFlushbar(context, message: texts.fiat_currencies_save_fail);
    });
  }
}
