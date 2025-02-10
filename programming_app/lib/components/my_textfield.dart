import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key, required this.hintText, required this.controller});

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        maxLines: 4,
        minLines: 1,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.cardColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor),
          ),
          fillColor: theme.cardColor,
          filled: true,
          hintText: hintText,
          hintStyle: theme.textTheme.labelSmall,
        ),
      ),
    );
  }
}
