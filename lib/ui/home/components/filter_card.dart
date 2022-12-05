import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  const FilterCard({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
            style: const TextStyle(color: ByatColors.white), child: child),
      ),
    );
  }
}
