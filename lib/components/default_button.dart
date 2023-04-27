import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.onPressed,
    required this.label,
    super.key,
  });

  final void Function() onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(label),
      ),
    );
  }
}
