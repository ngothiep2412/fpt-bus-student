import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/colors.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    Key? key,
    required this.title,
    this.route = '/404',
    this.extend = true,
    this.fontSize = 20.0,
    this.arg,
    this.length = 0,
  }) : super(key: key);

  final String title;
  final String route;
  final bool extend;
  final double fontSize;
  final arg;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: secondary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        (extend)
            ? GestureDetector(
                onTap: () {
                  Get.toNamed('/navigation/home/list_trip_today');
                },
                child: length <= 4
                    ? Container()
                    : Text(
                        'See More',
                        style: TextStyle(
                            color: AppColor.busdetailColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                      ),
              )
            : Container(),
      ],
    );
  }
}
