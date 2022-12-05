import 'package:byat_flutter/ui/app/byat_app.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

const SEARCHED_HISTORY_KEY = 'search_history_key';
const THEME_STATUS_KEY = 'theme_dark_mode_key';
late final SharedPreferences? pref;
void main() async {
  await _init();
  runApp(ByatApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  pref = await SharedPreferences.getInstance();
}
