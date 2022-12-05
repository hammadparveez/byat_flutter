import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/logo.png', height: 40, width: 40),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
