import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final bool isPass;
  final String? label;
  final TextInputType? keyBoardType;
  const AppTextField({super.key, required this.hintText, required this.controller, this.validator, this.prefix, this.suffix, this.isPass = false, required this.keyBoardType, this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      obscureText: isPass,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.07),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          prefix: prefix,
          suffixIcon: suffix,
          label: label != null ? Text(label!) : null,
          filled: true,
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}