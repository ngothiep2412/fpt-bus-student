import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final EdgeInsets padding;
  final TextEditingController textController;
  final TextInputType textInputType;

  CustomTextInput({
    required this.hintText,
    this.padding = const EdgeInsets.only(left: 40),
    required this.textController,
    required this.textInputType,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const ShapeDecoration(
        color: AppColor.textColor,
        shape: StadiumBorder(),
      ),
      child: TextField(
        controller: textController,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColor.placeholder,
          ),
          contentPadding: padding,
        ),
      ),
    );
  }
}
