import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class NotificationIcon extends StatelessWidget {
  final int notificationCount;

  const NotificationIcon({Key? key, this.notificationCount = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed('/navigation/home/notifications');
          },
          child: Icon(
            Ionicons.notifications,
            color: Colors.white,
            size: 30,
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            left: 8,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                notificationCount > 99
                    ? notificationCount.toString()
                    : notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
