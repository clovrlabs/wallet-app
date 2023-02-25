import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFormFieldApp extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final TextEditingController peerController;
  final String label;
  final Color primaryColor;
  final Color hintColor;
  final Color indicatorColor;
  final Color highlightColor;
  final Color errorColor;
  final Color cursorColor;
  final Color enabledBorder;
  final Color disabledBorder;
  final Color txtColor;

  const TextFormFieldApp({
    Key key,
    @required this.validator,
    @required this.peerController,
    @required this.label,
    @required this.primaryColor,
    @required this.hintColor,
    @required this.indicatorColor,
    @required this.highlightColor,
    @required this.errorColor,
    @required this.enabledBorder,
    @required this.disabledBorder,
    @required this.cursorColor,
    @required this.txtColor,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Theme(
      data: ThemeData().copyWith(
        primaryColor: primaryColor,
        hintColor: hintColor,
        indicatorColor: indicatorColor,
        highlightColor: highlightColor,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: errorColor,
          ),
          errorStyle: TextStyle(
            color: errorColor,
          ),
          hintStyle: TextStyle(
            color: hintColor,
          ),
        ),
      ),
      child: TextFormField(
        cursorColor: cursorColor,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: enabledBorder,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: disabledBorder,
            ),
          ),
          labelText: label ?? texts.network_bitcoin_node,
        ),
        style: TextStyle(
          color: txtColor,
        ),
        controller: peerController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      ),
    );
  }
}
