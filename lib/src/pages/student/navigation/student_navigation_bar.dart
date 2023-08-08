import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/pages/student/home/home_page.dart';
import 'package:fbus_app/src/pages/student/navigation/student_navigation_bar_controller.dart';
import 'package:fbus_app/src/pages/student/searchTrip/search_trip_page.dart';
import 'package:fbus_app/src/pages/student/more/more_page.dart';
import 'package:fbus_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class StudentNavigationBar extends StatelessWidget {
  StudentNavigationBarController con =
      Get.put(StudentNavigationBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(() => IndexedStack(
            index: con.indexTab.value,
            children: [
              HomePage(),
              SearchTripPage(),
              // TransactionPage(),
              MorePage(),
            ],
          )),
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
          containerHeight: 56,
          backgroundColor: AppColor.placeholderBg,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          selectedIndex: con.indexTab.value,
          onItemSelected: (index) => con.changeTab(index),
          items: [
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Ionicons.home_outline),
                title: Text("Home"),
                activeColor: AppColor.busdetailColor,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Ionicons.search),
                title: Text("Search Trip"),
                activeColor: AppColor.busdetailColor,
                inactiveColor: Colors.black),
            // BottomNavyBarItem(
            //     textAlign: TextAlign.center,
            //     icon: Icon(Ionicons.newspaper_outline),
            //     title: Text("Transaction"),
            //     activeColor: AppColor.orange,
            //     inactiveColor: Colors.black),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Ionicons.settings_outline),
                title: Text("More"),
                activeColor: AppColor.busdetailColor,
                inactiveColor: Colors.black),
          ],
        ));
  }
}
