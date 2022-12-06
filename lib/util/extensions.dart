import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  
  ///Padding
  EdgeInsets get padding => MediaQuery.of(this).padding;
  ///Top Padding
  double get topInsetPadding => MediaQuery.of(this).padding.top;
  ///Device Height
  double get deviceHeight => MediaQuery.of(this).size.height;
  ///Device Width
  double get deviceWidth => MediaQuery.of(this).size.width;

  ///MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ///ThemeData
  ThemeData get theme => Theme.of(this);
  ///TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;
  ///ColorScheme
   ColorScheme get colorScheme => Theme.of(this).colorScheme;
   ///ColorScheme -> Primary Color
   Color get primaryColor => Theme.of(this).colorScheme.primary;
   ///ColorScheme -> onPrimary Color
   Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
}

extension StringExtension on String {
  String toCapitalize() => this[0].toUpperCase() + substring(1).toLowerCase();
}

extension ListExtension on List {
  List<String> modifyToLowerCase() =>
      map((e) => (e as String).toLowerCase()).toList();
  List<String> modifyToUpperCase() =>
      map((e) => (e as String).toLowerCase()).toList();
  List<String> modifyToCapitalize() =>
      map((e) => (e as String).toCapitalize()).toList();
}
