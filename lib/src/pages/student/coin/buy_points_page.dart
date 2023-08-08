import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/pages/student/coin/buy_points_controller.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyCoinPage extends StatefulWidget {
  const BuyCoinPage({Key? key}) : super(key: key);

  @override
  _BuyCoinPageState createState() => _BuyCoinPageState();
}

class _BuyCoinPageState extends State<BuyCoinPage> {
  final _controller = TextEditingController();
  bool _isTextFieldValid = false;
  BuyPointsController con = Get.put(BuyPointsController());

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

    return Scaffold(
      appBar: CustomAppBar(
        titleString: "Buy Coins",
        context: context,
        implementLeading: true,
        notification: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'Enter the number of coins to buy:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.text1Color,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0',
                suffixText: 'Coin',
                errorText: _isTextFieldValid ? null : 'Invalid amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _isTextFieldValid =
                      int.tryParse(value) != null && int.parse(value) >= 0;
                });
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total money:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.text1Color,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${currencyFormat.format(_isTextFieldValid ? int.parse(_controller.text) * 1000 : 0)}đ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.busdetailColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTextFieldValid
                    ? () {
                        con.makePayment(context, _controller.text);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
