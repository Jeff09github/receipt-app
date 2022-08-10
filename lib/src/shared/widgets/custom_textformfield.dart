import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.initialValue,
    required this.validate,
    required this.onChanged,
    required this.textInputType,
    required this.textInputFormatters,
  }) : super(key: key);

  final String labelText;
  final String? initialValue;
  final String? Function(String?) validate;
  final Function(String) onChanged;
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      initialValue: initialValue,
      inputFormatters: textInputFormatters,
      keyboardType: textInputType,
      onChanged: onChanged,
      validator: validate,
    );
  }
}
