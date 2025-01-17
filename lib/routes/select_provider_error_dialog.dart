import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showProviderErrorDialog(
  BuildContext context,
  String error,
  Function() onSelect,
) {
  final themeData = Theme.of(context);
  final texts = AppLocalizations.of(context);

  promptError(
    context,
    texts.select_provider_error_dialog_title,
    RichText(
      text: TextSpan(
        style: themeData.dialogTheme.contentTextStyle,
        text: error != null
            ? texts.select_provider_error_dialog_message_error
            : texts.select_provider_error_dialog_message,
        children: [
          TextSpan(
            text: texts.select_provider_error_dialog_select_provider_begin,
            style: theme.blueLinkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                Navigator.of(context).pop();
                onSelect();
              },
          ),
          TextSpan(
            text: texts.select_provider_error_dialog_select_provider_end,
            style: themeData.dialogTheme.contentTextStyle,
          ),
        ],
      ),
    ),
  );
}
