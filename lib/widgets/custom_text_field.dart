import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final Function(String val)? onChanged;
  final double height;
  final TextInputAction? inputAction;

  const CustomTextField({
    this.hint,
    this.height = 54.0,
    this.onChanged,
    this.inputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        style: Theme.of(context).textTheme.caption,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textInputAction: inputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none),
      ),
      decoration: BoxDecoration(
          color: Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(5.0),
        ),
    );
  }
}
