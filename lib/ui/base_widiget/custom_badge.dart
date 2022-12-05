import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    Key? key,
    this.onTap,
    required this.title,
    this.backgroundColor = ByatColors.primary,
    this.titleColor = ByatColors.white,
  }) : super(key: key);
  final VoidCallback? onTap;
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
      ),
    );
  }
}
