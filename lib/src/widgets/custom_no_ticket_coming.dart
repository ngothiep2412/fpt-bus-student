import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/pages/student/searchTrip/search_trip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../core/const/promotion.dart';
import '../theme/colors.dart';
import '../theme/padding.dart';

class CustomNoTicketComing extends StatefulWidget {
  const CustomNoTicketComing({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomNoTicketComing> createState() => _CustomNoTicketComingState();
}

class _CustomNoTicketComingState extends State<CustomNoTicketComing> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size.width,
            height: size.width * .38,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange,
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NO TICKET",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColor.busdetailColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "      FOR TODAY",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColor.busdetailColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7.0),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/navigation/home/list_trip_today');
                  },
                  child: Container(
                    height: 35.0,
                    width: 100.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.busdetailColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.busdetailColor.withOpacity(0.5),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -20.0,
            right: 20.0,
            child: Container(
              height: size.width * .4,
              child: SvgPicture.asset(
                Promotion['image'].toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
