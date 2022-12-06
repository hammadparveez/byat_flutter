import 'package:byat_flutter/provider/auth_provider.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
import 'package:byat_flutter/provider/locale_provider.dart';

import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/provider/theme_provider.dart';
import 'package:byat_flutter/routes.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

class ByatApp extends StatelessWidget {
  ByatApp({super.key});
  final localePath = 'assets/translations';

  static const _textTheme = TextTheme(headline5: ByatStyles.heading5);

  final lightTheme = ThemeData(
    indicatorColor: ByatColors.primaryDark,
    cardColor: ByatColors.primary,
    colorScheme: const ColorScheme.light(
      primary: ByatColors.primary,
    ),
    textTheme: _textTheme,
  );

  final darkTheme = ThemeData(
      indicatorColor: ByatColors.white,
      colorScheme: const ColorScheme.dark(
        onPrimary: ByatColors.white,
        primary: ByatColors.primary,
        surface: ByatColors.primary,
        secondary: ByatColors.white,
      ),
      textTheme: _textTheme);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _getProviders(),
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: localePath,
        fallbackLocale: const Locale('en'),
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'Byat Test App',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            themeMode: context.watch<ThemeProvider>().themeMode,
            darkTheme: darkTheme,
            theme: lightTheme,
            onGenerateRoute: ByatRoute.onGenerateRoute,
            initialRoute: ByatRoute.main,
          );
        }),
      ),
    );
  }

  List<SingleChildWidget> _getProviders() {
    return [
      Provider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => FilterProvider()),
      ChangeNotifierProxyProvider<FilterProvider, SearchProvider>(
          create: (_) => SearchProvider(),
          update: (_, filterProvider, searchProvider) =>
              searchProvider!..update(filterProvider)),
    ];
  }
}
