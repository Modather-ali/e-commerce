import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SuperTextField extends StatelessWidget {
  SuperTextField({
    Key? key,
    required this.fieldName,
    required this.textInputType,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  final String fieldName;
  final TextInputType? textInputType;
  TextInputAction? textInputAction;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool obscureText;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        scrollPadding: const EdgeInsets.all(50),
        keyboardType: textInputType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.indigo,
              width: 2.0,
            ),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide(width: 2.0)),
          label: Text(fieldName),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
