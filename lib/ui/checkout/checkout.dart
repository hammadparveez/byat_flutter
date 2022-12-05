import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutUI extends StatelessWidget {
  const CheckoutUI({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(tabs: [
              Tab(child: Text('byat'.tr())),
              Tab(child: Text('ryat'.tr())),
            ]),
          ),
          Expanded(
            child: TabBarView(children: [
              Center(child: Text('byat'.tr())),
              Center(child: Text('byat_test_app'.tr())),
            ]),
          ),
        ],
      ),
    );
  }
}
