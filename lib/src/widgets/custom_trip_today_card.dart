import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/core/helpers/image_helper.dart';
import 'package:fbus_app/src/utils/helper.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomTripTodayCard extends StatefulWidget {
  const CustomTripTodayCard({
    Key? key,
    required this.departureTime,
    required this.ticketQuantity,
    required this.departure,
    required this.destination,
    required this.price,
  }) : super(key: key);

  final String departureTime;
  final String ticketQuantity;
  final String departure;
  final String destination;
  final String price;

  @override
  _CustomTripTodayCardState createState() => _CustomTripTodayCardState();
}

class _CustomTripTodayCardState extends State<CustomTripTodayCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .6,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: textWhite,
        borderRadius: BorderRadius.circular(17.0),
        boxShadow: [
          BoxShadow(
            color: textBlack.withOpacity(0.1),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                height: size.width * .63,
                width: size.width * .6,
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Departure: ',
                      style: TextStyle(
                        color: secondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ImageHelper.loadFromAsset(
                            Helper.getAssetIconName('ico_location.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.departure.length > 20
                                ? "${widget.departure.substring(0, 20)}..."
                                : widget.departure,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.text1Color,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Destination: ',
                      style: TextStyle(
                        color: secondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ImageHelper.loadFromAsset(
                            Helper.getAssetIconName('ico_location.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.destination.length > 20
                                ? "${widget.destination.substring(0, 20)}..."
                                : widget.destination,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.text1Color,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Departure Time: ',
                      style: TextStyle(
                        color: secondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ImageHelper.loadFromAsset(
                            Helper.getAssetIconName('ico_location.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.departureTime,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.text1Color,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 7.0,
              right: 7.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.ticketQuantity} Seat',
                  style: TextStyle(
                      color: secondary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Text(
                      widget.price.toString(),
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
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
