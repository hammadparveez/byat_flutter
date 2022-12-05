import 'package:byat_flutter/main.dart';
import 'package:byat_flutter/routes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String? _themeStatusText;
  ThemeMode get themeMode {
    final savedThemeMode = pref?.getBool(THEME_STATUS_KEY);
    if (savedThemeMode != null) {
      _themeMode = savedThemeMode ? ThemeMode.dark : ThemeMode.light;
    }
    return _themeMode;
  }

  void toggleMode() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    pref?.setBool(
        THEME_STATUS_KEY, _themeMode == ThemeMode.dark ? true : false);

    notifyListeners();
  }
}
