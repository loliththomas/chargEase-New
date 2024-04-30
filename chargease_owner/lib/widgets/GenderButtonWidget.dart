import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final String gender;
  final String selectedGender;
  final void Function(String) onPressed;

  const GenderButton({
    required this.gender,
    required this.selectedGender,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = selectedGender == gender
        ? Color.fromARGB(255, 27, 173, 193)
        : Colors.grey;

    return SizedBox(
      width: 100,
      height: 30,
      child: OutlinedButton(
        onPressed: () {
          onPressed(gender);
        },
        child: Text(
          gender,
          style: TextStyle(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(
            color: Color.fromARGB(255, 115, 111, 111),
          ),
        ),
      ),
    );
  }
}
