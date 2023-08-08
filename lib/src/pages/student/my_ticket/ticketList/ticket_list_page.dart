import 'dart:convert';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/widgets/skelton.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fbus_app/main.dart';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/llist_ticket_model.dart';
import 'package:fbus_app/src/models/response_api_pagination.dart';
import 'package:fbus_app/src/pages/student/my_ticket/ticketList/ticket_list_controller.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class TicketListPage extends StatefulWidget {
  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final controller = ScrollController();

  int _limit = 3;
  List<ListTicketModel> ticketList = [];

  int _page = 1;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  // const TicketListPage({super.key});
  TicketListController con = Get.put(TicketListController());

  double screenHeight = 0;

  double screenWidth = 0;

  var backgroundColor = Color.fromARGB(255, 229, 228, 234);
  _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        String? jwtToken = await storage.read(key: 'jwtToken');
        Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket',
            {'limit': _limit.toString(), 'page': _page.toString()});
        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        };

        final http.Response response = await http.get(
          uri,
          headers: headers,
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List responseApi = ResponseApiPagination.fromJson(data).data;
          if (responseApi.isNotEmpty) {
            setState(() {
              ticketList.addAll(responseApi
                  .map((item) => ListTicketModel.fromJson(item))
                  .toList());
            });
          } else {
            setState(() {
              _hasNextPage = false;
              Fluttertoast.showToast(
                msg: 'You have fetched all of your tickets list.',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.busdetailColor,
                textColor: Colors.white,
              );
            });
          }
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String? jwtToken = await storage.read(key: 'jwtToken');
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/ticket',
          {'limit': _limit.toString(), 'page': _page.toString()});
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final http.Response response = await http.get(
        uri,
        headers: headers,
      );

      // Handle the response from the API
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List responseApi = ResponseApiPagination.fromJson(data).data;

        ticketList =
            responseApi.map((item) => ListTicketModel.fromJson(item)).toList();

        print('ticketList: ${ticketList[0].status}');
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    // ticketList =
    //     con.rawList.map((item) => ListTicketModel.fromJson(item)).toList();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleString: 'My Ticket',
        implementLeading: true,
        notification: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _page = 1;
            _limit = 3;
            _hasNextPage = true;
          });
          await _firstLoad();
        },
        child: _isFirstLoadRunning
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 15,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 220,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 15,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 200,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 15,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Skelton(
                          height: 100,
                          width: 370,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : ticketList.isEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                            child: Text(
                              "No Ticket",
                              style: TextStyle(
                                color: AppColor.busdetailColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 300,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ticketList.length <= 2
                          ? Expanded(
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height,
                                ),
                                child: ListView.builder(
                                  // controller: _controller,
                                  itemCount: ticketList.length,
                                  itemBuilder: (context, index) {
                                    return item(index);
                                    // if (ticketList[index].status) {
                                    //   return item(index);
                                    // } else {
                                    //   return Container(
                                    //     margin: EdgeInsets.only(top: 50),
                                    //     child: Center(
                                    //       child: Text(
                                    //         "No Ticket",
                                    //         style: TextStyle(
                                    //           color: AppColor.busdetailColor,
                                    //           fontSize: 18,
                                    //           fontWeight: FontWeight.w600,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   );
                                    // }
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                controller: _controller,
                                itemCount: ticketList.length,
                                itemBuilder: (context, index) {
                                  return item(index);
                                  // if (ticketList[index].status) {
                                  //   return item(index);
                                  // } else {
                                  //   return Container(
                                  //     margin: EdgeInsets.only(top: 50),
                                  //     child: Center(
                                  //       child: Text(
                                  //         "No Ticket",
                                  //         style: TextStyle(
                                  //           color: AppColor.busdetailColor,
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.w600,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   );
                                  // }
                                },
                              ),
                            ),
                      if (_isLoadMoreRunning == true)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }

  Widget item(int index) {
    print('index: $index');
    const marginHorizontal = 20.0;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Text(
                DateFormat('yyyy-MM-dd')
                    .format(ticketList[index].trip.departureDate),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.text1Color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
            onTap: () {
              print('ID: ${ticketList[index].id}');
              con.handleTicketSelection(ticketList[index].id, context);
            },
            child: Stack(children: [
              Container(
                width: screenWidth,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.busdetailColor.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    left: marginHorizontal,
                    right: marginHorizontal),
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 2 / 7,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      // color: Colors.grey.withOpacity(0.1),
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              ticketList[index].qrUrl,
                              width: (screenWidth),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                          DottedLine(
                            direction: Axis.vertical,
                            dashColor: AppColor.busdetailColor.withOpacity(0.2),
                            lineLength: 200,
                            lineThickness: 4,
                          ),
                          Container(
                            width: 30,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth -
                          (screenWidth * 2 / 7) -
                          30 -
                          marginHorizontal * 2,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     offset: Offset(10, 0),
                        //     blurRadius: 10.0,
                        //     spreadRadius: 0.2,
                        //   ),
                        // ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ticketList[index].id.length > 15
                                      ? "ID: ${ticketList[index].id.substring(0, 15)}..."
                                      : ticketList[index].id,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.text1Color,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Departure Time",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.text1Color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                ticketList[index].trip.departureTime,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Departure",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.text1Color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                ticketList[index].trip.route.departure,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Destination",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.text1Color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ticketList[index].trip.route.destination,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  iconSize: 40,
                  color: AppColor.busdetailColor,
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Delete',
                            style: TextStyle(
                              color: AppColor.text1Color,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to delete a ticket with ID :${ticketList[index].id}?',
                            style: TextStyle(
                              color: AppColor.text1Color,
                              fontSize: 20,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColor.busdetailColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: AppColor.busdetailColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                ProgressDialog progressDialog =
                                    ProgressDialog(context: context);
                                String? jwtToken =
                                    await storage.read(key: 'jwtToken');
                                // progressDialog.show(
                                //   max: 200,
                                //   msg: 'Loading.....',
                                //   progressValueColor: Colors.white,
                                //   progressBgColor: AppColor.orange,
                                //   // msgColor: Colors.black,
                                // );
                                if (jwtToken != null) {
                                  try {
                                    ResponseApi responseApi =
                                        await ticketProviders.deleteTicket(
                                            jwtToken, ticketList[index].id);
                                    print(
                                        'responseApi test: ${responseApi.data}');
                                    print(
                                        'responseApi test: ${responseApi.message}');
                                    // progressDialog.close();
                                    if (responseApi.message ==
                                        "You can not cancel this ticket") {
                                      Get.snackbar(
                                          "FAIL", '${responseApi.message}');
                                    } else if (responseApi.message ==
                                        "Cancel ticket successfully") {
                                      Get.snackbar(
                                          "Success", '${responseApi.message}');
                                      setState(() {
                                        _limit = 3;
                                        _page = 1;
                                      });
                                      await _firstLoad();
                                    } else {}
                                  } catch (e) {
                                    Get.snackbar("ERROR", "SERVER");
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ])),
      ],
    );
  }
}
