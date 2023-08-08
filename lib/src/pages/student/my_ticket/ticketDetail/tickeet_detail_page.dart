import 'package:dotted_border/dotted_border.dart';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/pages/student/my_ticket/ticketDetail/ticket_detail_controller.dart';
import 'package:intl/intl.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDetail extends StatefulWidget {
  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  // const TicketScreen({super.key});
  double? screenHeight;

  double? screenWidth;
  TicketDetailController con = Get.put(TicketDetailController());
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    double ticketWidth = screenWidth! * 5 / 5.5;
    double ticketHeight = screenHeight! * 4 / 5.5;

    var unValidColor = Colors.redAccent;
    var validColor = Colors.greenAccent;
    var bookingColor = Colors.orangeAccent;

    return Scaffold(
      backgroundColor: Color.fromARGB(236, 244, 238, 238),
      appBar: CustomAppBar(
        titleString: 'Ticket Detail',
        notification: false,
        implementLeading: false,
        context: context,
        home: true,
      ),
      body: SafeArea(
          child: Center(
        child: Stack(children: [
          Container(
            width: ticketWidth,
            height: ticketHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              // color: Colors.orangeAccent,
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //check valid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bus Ticket",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColor.busdetailColor,
                        ),
                      ),
                      if (con.ticket.status == "BOOKING")
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1.5, color: bookingColor)),
                          child: Row(
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/157/157977.png",
                                width: 20,
                                height: 20,
                                color: bookingColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                // "valid",
                                "BOOKING",
                                style: TextStyle(
                                    color: bookingColor,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      if (con.ticket.status == "CANCEL")
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1.5, color: unValidColor)),
                          child: Row(
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/262/262037.png",
                                width: 20,
                                height: 20,
                                color: unValidColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                // "valid",
                                "CANCEL",
                                style: TextStyle(
                                    color: unValidColor,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      if (con.ticket.status == "EXPIRED")
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1.5, color: unValidColor)),
                          child: Row(
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/262/262037.png",
                                width: 20,
                                height: 20,
                                color: unValidColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                // "valid",
                                "EXPIRED",
                                style: TextStyle(
                                    color: unValidColor,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      if (con.ticket.status == "USED")
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1.5, color: validColor)),
                          child: Row(
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/512/157/157977.png",
                                width: 20,
                                height: 20,
                                color: validColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                // "valid",
                                "USED",
                                style: TextStyle(
                                    color: validColor,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //trip
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(TextSpan(
                              text: "From  ",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: con.ticket.trip.route.departure,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text1Color,
                                    ))
                              ])),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Image.network(
                          "https://cdn-icons-png.flaticon.com/128/1023/1023413.png",
                          width: 30,
                          height: 30,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text.rich(TextSpan(
                              text: "To  ",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: con.ticket.trip.route.destination,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text1Color,
                                    ))
                              ])),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //in4
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    // color: Colors.amber,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ticketWidth * 7 / 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Student name",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.3),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    con.user.fullname ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text1Color,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: ticketWidth * 4 / 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.3),
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd')
                                        .format(con.tripDetail.departureDate),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text1Color,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: ticketWidth * 7 / 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Driver name",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    con.tripDetail.driverName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text1Color,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: ticketWidth * 4 / 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Time",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    con.tripDetail.departureTime,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text1Color,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(4),
                      padding: EdgeInsets.all(6),
                      color: AppColor.busdetailColor,
                      child: Text(
                        con.tripDetail.licensePlate,
                        style: TextStyle(
                          color: AppColor.text1Color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                      con.ticket.qrUrl,
                      width: 180,
                      height: 180,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: ticketHeight / 2 - 20,
              left: -20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(238, 239, 235, 235),
                  borderRadius: BorderRadius.circular(100),
                ),
              )),
          Positioned(
              top: ticketHeight / 2 - 20,
              right: -20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(238, 239, 235, 235),
                  borderRadius: BorderRadius.circular(100),
                ),
              )),
        ]),
      )),
    );
  }
}
