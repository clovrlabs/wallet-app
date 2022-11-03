import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/withdraw_funds/tx_widget_with_info_message.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SwapInProgress extends StatelessWidget {
  final InProgressReverseSwaps swapInProgress;

  const SwapInProgress({
    Key key,
    this.swapInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(onPressed: () {}),
        title: Text(texts.swap_in_progress_title),
      ),
      body: TxWidgetWithInfoMsg(swapInProgress: swapInProgress),
    );
  }
}
