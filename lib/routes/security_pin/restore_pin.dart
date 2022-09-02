import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RestorePinCode extends StatelessWidget {
  final Function(String phrase) onPinCodeSubmitted;

  const RestorePinCode({
    Key key,
    @required this.onPinCodeSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: backBtn.BackButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
        ),
        body: PinCodeWidget(
          texts.restore_pin_title,
          (enteredPinCode) => _onPinEntered(enteredPinCode),
        ),
      ),
    );
  }

  Future _onPinEntered(String enteredPinCode) {
    onPinCodeSubmitted(enteredPinCode);
    return Future.value(null);
  }
}
