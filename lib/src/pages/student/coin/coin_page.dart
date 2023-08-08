import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/core/helpers/image_helper.dart';
import 'package:fbus_app/src/pages/student/coin/coin_controller.dart';
import 'package:fbus_app/src/utils/helper.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCoinPage extends StatefulWidget {
  @override
  State<MyCoinPage> createState() => _MyCoinPageState();
}

class _MyCoinPageState extends State<MyCoinPage> {
  CoinController con = Get.put(CoinController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleString: "My Coin",
        context: context,
        implementLeading: true,
        notification: false,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Your coin: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColor.busdetailColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Text(
                    con.myBlance.value.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: AppColor.busdetailColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ImageHelper.loadFromAsset(
                    Helper.getAssetIconName('ico_coin.png')),
              ],
            )),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                con.goToBuyPoint();
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buy Points',
                              style: TextStyle(
                                color: AppColor.text1Color,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Exchange affiliate points for points',
                              style: TextStyle(
                                color: AppColor.text1Color,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        ClipOval(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/money_transfer.jpg'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
