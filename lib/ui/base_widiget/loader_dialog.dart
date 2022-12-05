import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if(title != null)
           const SizedBox(height: 8),
          if(title != null)
          Text(title!)
        ],
      ),
    );
  }
}
