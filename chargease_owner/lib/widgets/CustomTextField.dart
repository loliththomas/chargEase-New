import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.prefixIcon,
    this.keyboardType,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 10.0,
          ),
        ),
        style: TextStyle(fontSize: 16.0),
        keyboardType: keyboardType,
        validator: (value) {
          if (labelText.toLowerCase() == 'email') {
            if (!RegExp(r'^.+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!)) {
              return 'Enter a valid email address';
            }
          }
          if(value==null || value.isEmpty){
            return 'Please Fill the Field';
          }
          return null;
        },
      ),
    );
  }
}
