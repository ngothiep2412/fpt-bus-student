import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';

class OtpTextField extends StatelessWidget {
  final TextEditingController controller;
  final int size;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;

  OtpTextField({
    required this.controller,
    required this.size,
    required this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: ShapeDecoration(
        color: AppColor.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 35.0,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          obscureText: true,
          maxLength: 1,
          autofocus: true,
          onChanged: onChanged,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
