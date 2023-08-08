import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';

class CustomFormInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const CustomFormInput({
    required this.label,
    required this.isPassword,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _CustomFormInputState createState() => _CustomFormInputState();
}

class _CustomFormInputState extends State<CustomFormInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        obscureText: widget.isPassword,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
