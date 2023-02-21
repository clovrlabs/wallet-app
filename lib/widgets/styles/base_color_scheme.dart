import 'package:flutter/material.dart';

/// This class ensures that app color scheme is compatible with
/// Material [ColorScheme] pallet so build in components looks good with
/// our custom implementation.
abstract class BaseColorScheme {
  const BaseColorScheme({
    @required this.brightness,
    @required this.primary,
    @required this.onPrimary,
    @required this.primaryContainer,
    @required this.onPrimaryContainer,
    @required this.secondary,
    @required this.onSecondary,
    @required this.secondaryContainer,
    @required this.onSecondaryContainer,
  });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  ColorScheme get materialColorScheme => ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
      );
}
