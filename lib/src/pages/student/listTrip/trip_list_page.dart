import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/core/helpers/image_helper.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/pages/student/listTrip/trip_list_controller.dart';
import 'package:fbus_app/src/utils/helper.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripListPage extends StatefulWidget {
  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  TripListController con = Get.put(TripListController());
  List<TripModel> _tripList = [];
  double screenWidth = 0;

  void _firstLoad() {
    _tripList = con.trips
        .where((trip) => DateTime.parse(
                "${DateTime.now().toString().split(' ')[0]} ${trip.departureTime}")
            .isAfter(DateTime.now()))
        .toList();
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
        titleString: "List The Trip",
        notification: false,
      ),
      body: _tripList.isEmpty
          ? const Center(
              child: Text(
                "No trip in this time",
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
                        itemCount: _tripList.length,
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
        con.handleTripSelection(index, context);
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
              height: 220,
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
                              _tripList[index].departure,
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
                              _tripList[index].destination,
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
                                  _tripList[index].departureTime,
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
                                _tripList[index].licensePlate,
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
                        _tripList[index].ticketQuantity.toString(),
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
