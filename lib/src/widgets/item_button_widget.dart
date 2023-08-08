import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';

class ItemButtonWidget extends StatelessWidget {
  const ItemButtonWidget({Key? key, required this.data, this.onTap, this.color})
      : super(key: key);

  final String data;
  final Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              AppColor.garidentColorFirst,
              AppColor.garidentColorSecond,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          data,
          style: color != null
              ? TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w400,
                  height: 16 / 14,
                )
              : TextStyle(
                  fontSize: 14,
                  color: AppColor.text1Color,
                  fontWeight: FontWeight.w400,
                  height: 16 / 14,
                ).copyWith(
                  color: AppColor.garidentColorFirst,
                ),
        ),
      ),
    );
  }
}
