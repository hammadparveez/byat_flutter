import 'package:byat_flutter/routes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocaleProvider {
  void toggleLang(BuildContext ctx) {
    if (ctx.locale.languageCode == 'en') {
      ctx.setLocale(const Locale('ar'));
    } else {
      ctx.setLocale(const Locale('en'));
    }
  }
}
