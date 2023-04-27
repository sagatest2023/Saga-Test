import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  const DefaultTextField(
    this.label,
    this.controller, {
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isSecret = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isSecret;

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();

    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: isObscure,
        controller: widget.controller,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
