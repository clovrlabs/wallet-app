import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/payment_options/payment_options_actions.dart';
import 'package:clovrlabs_wallet/bloc/payment_options/payment_options_bloc.dart';
import 'package:clovrlabs_wallet/utils/colors_ext.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/text_form_field_app.dart';
import 'package:clovrlabs_wallet/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/locator.dart';
import '../../widgets/styles/app_color_scheme.dart';
import '../../widgets/styles/lightning_fees_confs.dart';

class PaymentOptionsPage extends StatefulWidget {
  const PaymentOptionsPage({
    Key key,
  }) : super(key: key);

  @override
  State<PaymentOptionsPage> createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  final _baseFeeController = TextEditingController();
  final _proportionalFeeController = TextEditingController();

  bool _loadingOverride = false;
  bool _overriding = false;
  bool _loadingBaseFee = false;
  int _baseFee = 0;
  bool _loadingProportionalFee = false;
  double _proportionalFee = 0.0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final options = AppBlocsProvider.of<PaymentOptionsBloc>(context);
    options.paymentOptionsFeeEnabledStream.listen((overriding) {
      setState(() {
        _loadingOverride = false;
        _overriding = overriding;
      });
    });

    options.paymentOptionsProportionalFeeStream.listen((proportionalFee) {
      final proportionalFeeText = proportionalFee.toStringAsFixed(2);
      _proportionalFeeController.text = proportionalFeeText;

      setState(() {
        _loadingProportionalFee = false;
        _proportionalFee = proportionalFee;
      });
    });

    options.paymentOptionsBaseFeeStream.listen((baseFee) {
      final baseFeeText = baseFee.toString();
      _baseFeeController.text = baseFeeText;

      setState(() {
        _loadingBaseFee = false;
        _baseFee = baseFee;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final remoteConfigs = locator.get<AppConfigScheme>().lightningFeesConfs;

    return Scaffold(
      backgroundColor: remoteConfigs.bgColor.toColor(),
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: remoteConfigs.bgColor.toColor(),
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(
          color: remoteConfigs.backArrowColor.toColor(),
        ),
        title: Text(
          texts.payment_options_title,
          style: TextStyle(
            color: remoteConfigs.txtColorTitle.toColor(),
          ),
        ),
        elevation: 0.0,
      ),
      body: (_loadingOverride || _loadingBaseFee || _loadingProportionalFee)
          ? Container()
          : _body(context, remoteConfigs),
    );
  }

  Widget _body(BuildContext context, LightningFeesConfs remoteConfigs) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerFee(context, remoteConfigs),
          _overrideFee(context, remoteConfigs),
          _baseFeeWidget(context, remoteConfigs),
          _proportionalFeeWidget(context, remoteConfigs),
          _actionsFee(context, remoteConfigs),
          _warningBox(context, remoteConfigs),
        ],
      ),
    );
  }

  Widget _headerFee(BuildContext context, LightningFeesConfs remoteConfigs) {
    final texts = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              texts.payment_options_fee_header,
              style: TextStyle(
                color: remoteConfigs.txtSubtitleFees.toColor(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _overrideFee(BuildContext context, LightningFeesConfs remoteConfigs) {
    final texts = AppLocalizations.of(context);

    return Theme(
      data: ThemeData(
        unselectedWidgetColor: remoteConfigs.txtEnforceFees.toColor(),
        primaryColor: remoteConfigs.txtEnforceFees.toColor(),
      ),
      child: CheckboxListTile(
        activeColor: remoteConfigs.checkBoxFees.toColor(),
        checkColor: remoteConfigs.bgColor.toColor(),
        controlAffinity: ListTileControlAffinity.leading,
        value: _overriding,
        onChanged: (value) => setState(() => _overriding = value),
        title: Text(
          texts.payment_options_fee_override_enable,
          style: TextStyle(
            color: remoteConfigs.txtEnforceFees.toColor(),
          ),
        ),
      ),
    );
  }

  Widget _baseFeeWidget(
      BuildContext context, LightningFeesConfs remoteConfigs) {
    final texts = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Form(
              child: TextFormFieldApp(
                enabled: _overriding,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                peerController: _baseFeeController,
                validator: (value) {
                  if (value.isEmpty) {
                    return texts.payment_options_base_fee_label;
                  }
                  try {
                    final newBaseFee = int.parse(value);
                    if (newBaseFee < 0) {
                      return texts.payment_options_base_fee_label;
                    }
                  } catch (e) {
                    return texts.payment_options_base_fee_label;
                  }
                  return null;
                },
                onChanged: (value) => _saveBase(context, value),
                label: texts.payment_options_proportional_fee_label,
                primaryColor: remoteConfigs.txtHintBaseFee.toColor(),
                hintColor: remoteConfigs.txtHintBaseFee.toColor(),
                indicatorColor: remoteConfigs.txtHintBaseFee.toColor(),
                highlightColor: remoteConfigs.txtHintBaseFee.toColor(),
                txtColor: remoteConfigs.txtBaseFee.toColor(),
                errorColor: remoteConfigs.txtHintBaseFee.toColor(),
                enabledBorder: remoteConfigs.txtHintBaseFee.toColor(),
                disabledBorder: remoteConfigs.txtHintBaseFee.toColor(),
                cursorColor: remoteConfigs.txtHintBaseFee.toColor(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _proportionalFeeWidget(
      BuildContext context, LightningFeesConfs remoteConfigs) {
    final texts = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Form(
              child: TextFormFieldApp(
                enabled: _overriding,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                peerController: _proportionalFeeController,
                validator: (value) {
                  if (value.isEmpty) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  try {
                    final newProportionalFee = double.parse(value);
                    if (newProportionalFee < 0.0) {
                      return texts.payment_options_proportional_fee_label;
                    }
                  } catch (e) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  return null;
                },
                onChanged: (value) => _saveProportional(context, value),
                label: texts.payment_options_proportional_fee_label,
                primaryColor: remoteConfigs.txtHintProportionalFee.toColor(),
                hintColor: remoteConfigs.txtHintProportionalFee.toColor(),
                indicatorColor: remoteConfigs.txtHintProportionalFee.toColor(),
                highlightColor: remoteConfigs.txtHintProportionalFee.toColor(),
                txtColor: remoteConfigs.txtProportionalFee.toColor(),
                errorColor: remoteConfigs.txtHintProportionalFee.toColor(),
                enabledBorder: remoteConfigs.txtHintProportionalFee.toColor(),
                disabledBorder: remoteConfigs.txtHintProportionalFee.toColor(),
                cursorColor: remoteConfigs.txtHintProportionalFee.toColor(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionsFee(BuildContext context, LightningFeesConfs remoteConfigs) {
    final texts = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: remoteConfigs.btOutlineResetColor.toColor(),
              ),
              backgroundColor: remoteConfigs.btBgResetColor.toColor(),
            ),
            child: Text(
              texts.payment_options_fee_action_reset,
              style: TextStyle(
                color: remoteConfigs.btTxtResetColor.toColor(),
              ),
            ),
            onPressed: () => _reset(context),
          ),
          SizedBox(width: 12.0),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: remoteConfigs.btOutlineResetColor.toColor(),
              ),
              backgroundColor: remoteConfigs.btBgResetColor.toColor(),
            ),
            child: Text(
              texts.payment_options_fee_action_save,
              style: TextStyle(
                color: remoteConfigs.btTxtResetColor.toColor(),
              ),
            ),
            onPressed: () {
              if (_overriding) {
                showDialog(
                  context: context,
                  builder: (context) => _saveDialog(context),
                );
              } else {
                _save(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _saveDialog(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.payment_options_fee_warning_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      content: Text(
        texts.payment_options_fee_warning_dialog_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      actions: [
        TextButton(
          child: Text(
            texts.payment_options_fee_action_cancel,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            texts.payment_options_fee_action_save,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () {
            _save(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _warningBox(BuildContext context, LightningFeesConfs remoteConfigs) {
    final texts = AppLocalizations.of(context);
    return WarningBox(
      backgroundColor: remoteConfigs.colorBgBanner.toColor(),
      borderColor: remoteConfigs.colorFrameBanner.toColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texts.payment_options_fee_warning,
            style: TextStyle(
              color: remoteConfigs.txtColorBanner.toColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _saveProportional(BuildContext context, String value) {
    double newProportionalFee = 0.0;
    try {
      newProportionalFee = double.parse(value);
    } catch (e) {
      return;
    }
    setState(() {
      _proportionalFee = newProportionalFee;
    });
  }

  void _saveBase(BuildContext context, String value) {
    int newBaseFee = 0;
    try {
      newBaseFee = int.parse(value);
    } catch (e) {
      return;
    }
    setState(() {
      _baseFee = newBaseFee;
    });
  }

  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _reset(BuildContext context) {
    final paymentOptions = AppBlocsProvider.of<PaymentOptionsBloc>(context);
    _proportionalFeeController.text = "";
    _baseFeeController.text = "";
    paymentOptions.actionsSink.add(ResetPaymentFee());
    _closeKeyboard();
  }

  void _save(BuildContext context) async {
    _saveProportional(context, _proportionalFeeController.text);
    _saveBase(context, _baseFeeController.text);
    _closeKeyboard();

    final options = AppBlocsProvider.of<PaymentOptionsBloc>(context);
    var updatePaymentProportionalFeeAction =
        UpdatePaymentProportionalFee(_proportionalFee);
    var updatePaymentBaseFeeAction = UpdatePaymentBaseFee(_baseFee);
    final overridePaymentFeeAction = OverridePaymentFee(_overriding);
    options.actionsSink.add(updatePaymentProportionalFeeAction);
    options.actionsSink.add(updatePaymentBaseFeeAction);
    options.actionsSink.add(overridePaymentFeeAction);
    Future.wait([
      updatePaymentProportionalFeeAction.future,
      updatePaymentBaseFeeAction.future,
      overridePaymentFeeAction.future
    ]).whenComplete(() {
      final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
      backupBloc.backupAppDataSink.add(true);
    });
  }
}
