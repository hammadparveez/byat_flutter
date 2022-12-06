import 'package:byat_flutter/ui/auth/login.dart';
import 'package:byat_flutter/ui/bottom_navigation/bottom_navigation.dart';

import 'package:byat_flutter/ui/user_detail/user_detail.dart';

import 'package:flutter/material.dart';

class ByatRoute {
  static const main = '/main';
  static const home = '/home';

  static const userDetail = '/user/detail';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return _pageWrapper(const LoginUI());
      case home:
        return _pageWrapper(
          const BottomNavigationUI(),
        );

      case userDetail:
        return _pageWrapper(const UserDetailUI(), settings: settings);
    }
  }

  static MaterialPageRoute _pageWrapper(Widget screen,
          {RouteSettings? settings}) =>
      MaterialPageRoute(builder: (_) => screen, settings: settings);
}
