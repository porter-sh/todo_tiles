/// This file contains the OutlinedTextFormField widget. A TextFormField with an
/// outline border.

import 'package:flutter/material.dart';

/// A TextFormField with an outline border.
class OutlinedTextFormField extends StatefulWidget {
  const OutlinedTextFormField({
    super.key,
    required this.text,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String text;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  State<OutlinedTextFormField> createState() => _OutlinedTextFormFieldState();
}

class _OutlinedTextFormFieldState extends State<OutlinedTextFormField> {
  bool obeyObscureText = true;

  Widget? getSuffixIcon() {
    if (widget.obscureText) {
      Widget? icon;
      if (obeyObscureText) {
        icon = IconButton(
          onPressed: () {
            setState(() {
              obeyObscureText = !obeyObscureText;
            });
          },
          icon: const Icon(Icons.visibility),
        );
      } else {
        icon = IconButton(
          onPressed: () {
            setState(() {
              obeyObscureText = !obeyObscureText;
            });
          },
          icon: const Icon(Icons.visibility_off),
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.text,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        suffixIcon: getSuffixIcon(),
      ),
      obscureText: obeyObscureText && widget.obscureText,
      keyboardType: widget.keyboardType,
    );
  }
}
