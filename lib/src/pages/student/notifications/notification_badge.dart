import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
            'Total notifications:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 30.0,
          height: 30.0,
          decoration: new BoxDecoration(
            color: AppColor.busdetailColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$totalNotifications',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
