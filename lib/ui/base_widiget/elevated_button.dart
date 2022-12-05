import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';

class ByatElevatedButton extends StatelessWidget {
  final double radius;
  final bool hasSuffixIcon;
  final IconData? suffixIcon;
  final String title;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const ByatElevatedButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.radius = 10,
    this.hasSuffixIcon = false,
    this.suffixIcon,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
            backgroundColor: _style(backgroundColor),
            padding:
                _style(const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
            shape: _style(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)))),
        child: Row(
          children: [
            Expanded(child: Center(child: Text(title))),
            if (hasSuffixIcon)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: ByatColors.primaryDark, shape: BoxShape.circle),
                child: suffixIcon != null
                    ? Icon(suffixIcon)
                    : const Icon(Icons.arrow_forward, size: 12),
              ),
          ],
        ));
  }

  MaterialStateProperty<T> _style<T>(T styleProperty) =>
      MaterialStateProperty.all(styleProperty);
}
