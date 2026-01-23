import 'package:flutter/material.dart';
import 'package:foodora/core/localization/app_localizations.dart';

/// Extension to make translations easier to use throughout the app
extension BuildContextExtension on BuildContext {
  /// Get the current localizations
  AppLocalizations get loc => AppLocalizations.of(this);
  
  /// Translate a key
  String tr(String key) => AppLocalizations.of(this).translate(key);
}
