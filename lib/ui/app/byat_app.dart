import 'package:byat_flutter/provider/auth_provider.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
import 'package:byat_flutter/provider/locale_provider.dart';

import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/provider/theme_provider.dart';
import 'package:byat_flutter/routes.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ByatApp extends StatelessWidget {
  ByatApp({super.key});
  final localePath = 'assets/translations';

  final lightTheme = ThemeData(
    indicatorColor: ByatColors.primaryDark,
    cardColor: ByatColors.primary,
    colorScheme: const ColorScheme.light(
      primary: ByatColors.primary,
    ),
  );

  final darkTheme = ThemeData(
    // cardColor: ByatColors.primary,
    indicatorColor: ByatColors.white,
    colorScheme: const ColorScheme.dark(
      onPrimary: ByatColors.white,
      primary: ByatColors.primary,
      surface: ByatColors.primary,
      secondary: ByatColors.white,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProxyProvider<FilterProvider, SearchProvider>(
            create: (_) => SearchProvider(),
            update: (_, filterProvider, searchProvider) =>
                searchProvider!..update(filterProvider)),
      ],
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
            navigatorKey: ByatRoute.navigatorKey,
          );
        }),
      ),
    );
  }
}
