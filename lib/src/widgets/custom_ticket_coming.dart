import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/widgets/custom_ticket_coming_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../core/const/promotion.dart';
import '../theme/colors.dart';
import '../theme/padding.dart';

class CustomTicketComing extends StatefulWidget {
  final String departureDate;
  final int timeLeft;
  final String routeName;
  final String ticketId;

  const CustomTicketComing({
    Key? key,
    required this.departureDate,
    required this.timeLeft,
    required this.routeName,
    required this.ticketId,
  }) : super(key: key);

  @override
  State<CustomTicketComing> createState() => _CustomTicketComingState();
}

class _CustomTicketComingState extends State<CustomTicketComing>
    with SingleTickerProviderStateMixin {
  CustomTicketComingController con = Get.put(CustomTicketComingController());

  @override
  void initState() {
    // String? timeString = widget.timeLeft;
    int timeLeft = widget.timeLeft;
    print('timeLeft: ${widget.timeLeft}');
    // List<String> parts = timeString.split(' ');
    // int hours = int.parse(parts[0]);
    // int minutes = int.parse(parts[3]);
    // int seconds = (hours * 60 + minutes) * 60;
    con.routeName = widget.routeName;
    con.seconds = timeLeft;
    super.initState();
  }

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
            height: size.width * .5,
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
                  'Coming ...',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: AppColor.busdetailColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7.0),
                Container(
                  width: size.width * .425,
                  child: Text(
                    'Name Route: ${widget.routeName}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColor.busdetailColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Container(
                  width: size.width * .425,
                  child: Text(
                    'Date: ${widget.departureDate}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColor.busdetailColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Obx(
                  () => Text('Time left: ${con.time.value}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColor.busdetailColor,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Spacer(),
                SizedBox(height: 7.0),
                GestureDetector(
                  onTap: () {
                    con.goToTicketDetail(widget.ticketId, context);
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
                      'Go Now',
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
