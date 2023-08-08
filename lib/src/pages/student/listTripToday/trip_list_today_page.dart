import 'dart:convert';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/core/helpers/image_helper.dart';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/pages/student/listTripToday/trip_list_today_controller.dart';
import 'package:fbus_app/src/utils/helper.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:fbus_app/src/widgets/skelton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TripListTodayPage extends StatefulWidget {
  @override
  State<TripListTodayPage> createState() => _TripListTodayPageState();
}

class _TripListTodayPageState extends State<TripListTodayPage> {
  TripListTodayController con = Get.put(TripListTodayController());
  FlutterSecureStorage storage = FlutterSecureStorage();
  double screenWidth = 0;
  bool listIsEmpty = false;
  bool _isFirstLoadRunning = false;
  List<TripModel> _tripListToday = [];

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true; // Display a progress indicator at the bottom
    });

    try {
      String key = 'student-today';
      String? jwtToken = await storage.read(key: 'jwtToken');
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/trip/$key');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final http.Response response = await http.get(
        uri,
        headers: headers,
      );
      // Handle the response from the API
      if (response.statusCode == 401) {
        Get.snackbar("Fail", "You are not logged into the system");
      }
      if (response.statusCode == 403) {
        Get.snackbar("Fail", "Access denied");
      }
      if (response.statusCode == 404) {
        setState(() {
          listIsEmpty = true;
        });
      }
      if (response.statusCode == 500) {
        Get.snackbar("Fail", "Internal server error");
      }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List responseApi = ResponseApi.fromJson(data).data;

        _tripListToday = responseApi
            .map((item) => TripModel.fromJson(item))
            .where((trip) => DateTime.parse(
                    "${DateTime.now().toString().split(' ')[0]} ${trip.departureTime}")
                .isAfter(DateTime.now()))
            .toList();
      }
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false; // Display a progress indicator at the bottom
    });
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        implementLeading: true,
        titleString: "List The Trip Today",
        notification: false,
      ),
      body: _isFirstLoadRunning
          ? Column(
              children: [
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
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Skelton(
                        height: 20,
                        width: 370,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _tripListToday.isEmpty
              ? const Center(
                  child: Text(
                    "No Trip Today",
                    style: TextStyle(
                      color: AppColor.busdetailColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : SafeArea(
                  child: Container(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth / 25,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          ListView.builder(
                            physics: BouncingScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: _tripListToday.length,
                            itemBuilder: (context, index) {
                              return itemListView(index);
                            },
                          ),
                          // const SizedBox(
                          //   height: 50,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget itemListView(int index) {
    return GestureDetector(
      onTap: () {
        con.handleTripSelection(_tripListToday[index].id, context);
      },
      child: AnimatedContainer(
        height: 220,
        width: screenWidth,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300 + (index * 200)),
        // transform:
        // Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
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

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: screenWidth,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Departure
                    Container(
                      padding: EdgeInsets.only(right: 45),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(
                              Helper.getAssetIconName('ico_location.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              _tripListToday[index].departure,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.text1Color,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //Destination
                    Container(
                      padding: EdgeInsets.only(right: 45),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(
                              Helper.getAssetIconName('ico_location.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              _tripListToday[index].destination,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.text1Color,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(),

                    //Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Time
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageHelper.loadFromAsset(
                                Helper.getAssetIconName('ico_time.png')),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 2,
                                      color: AppColor.busdetailColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  _tripListToday[index].departureTime,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.text1Color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //License
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/ico_license.png",
                                width: 36,
                                height: 36,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _tripListToday[index].licensePlate,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.text1Color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '10',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: AppColor.busdetailColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ImageHelper.loadFromAsset(
                            Helper.getAssetIconName('ico_coin.png')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              //Seat
              child: Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.busdetailColor,
                      width: 2,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _tripListToday[index].ticketQuantity.toString(),
                        style: TextStyle(
                            color: AppColor.busdetailColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      Text(
                        "seats",
                        style: TextStyle(
                            color: AppColor.text1Color,
                            fontWeight: FontWeight.w400,
                            fontSize: 11),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
