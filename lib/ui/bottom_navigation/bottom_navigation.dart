import 'package:byat_flutter/provider/locale_provider.dart';

import 'package:byat_flutter/ui/account/account.dart';

import 'package:byat_flutter/ui/checkout/checkout.dart';

import 'package:byat_flutter/ui/home/home.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomNavigationUI extends StatefulWidget {
  const BottomNavigationUI({this.appBar, super.key});
  final PreferredSizeWidget? appBar;
  @override
  State<BottomNavigationUI> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigationUI> {
  int _selectedIndex = 0;
  final screens = const [
    HomeUI(),
    CheckoutUI(),
    AccountUI(),
  ];

  _onSelectNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  refreshState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context, lang, child) {
      return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onSelectNavigation,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: 'home'.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.card_travel), label: 'checkout'.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person), label: 'account'.tr()),
          ],
        ),
      );
    });
  }
}
