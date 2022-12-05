import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton({
    Key? key,
    this.title,
    this.spacing = 8,
    this.selectedValue,
    this.groupValue,
    this.onSelect,
  }) : super(key: key);

  final String? title;
  final double spacing;
  final T? selectedValue;
  final T? groupValue;
  final void Function(T?)? onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onSelect != null && (selectedValue != groupValue)) {
          onSelect!(selectedValue);
        }
      },
      child: Row(
        children: [
          Radio<T?>(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            value: selectedValue,
            groupValue: groupValue,
            onChanged: onSelect ?? (_) {},
          ),
          if (title != null) SizedBox(width: spacing),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(title!),
            ),
        ],
      ),
    );
  }
}
