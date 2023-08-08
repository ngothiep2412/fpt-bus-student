import 'dart:convert';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/wallet_model.dart';
import 'package:fbus_app/src/pages/student/coin/coin_controller.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class BuyPointsController extends GetxController {
  FlutterSecureStorage storage = FlutterSecureStorage();
  CoinController coincontroller = Get.find();
  Map<String, dynamic>? paymentIntent;
  UsersProviders usersProviders = UsersProviders();
  Future<void> makePayment(BuildContext context, String amount) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    try {
      if (int.parse(amount) > 15 && int.parse(amount) < 10000) {
        if (jwtToken != null) {
          paymentIntent = await createPaymentIntent(amount, jwtToken);
          //Payment Sheet
          await Stripe.instance
              .initPaymentSheet(
                  paymentSheetParameters: SetupPaymentSheetParameters(
                      paymentIntentClientSecret:
                          paymentIntent!['client_secret'],
                      customFlow: true,
                      // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                      // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                      // style: ThemeMode.dark,
                      merchantDisplayName: 'F-BUS'))
              .then((value) {});

          ///now finally display payment sheeet
          displayPaymentSheet(context, jwtToken, amount);
        }
      } else {
        Get.snackbar("Fail",
            "Amount is required and amount must be greater than 15 or less than 1000 coin");
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(
      BuildContext context, String jwtToken, String amount) async {
    try {
      Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/payment/top-up');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };
      final Map<String, dynamic> body = {
        'amount': int.parse(amount),
      };
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        ResponseApi responseApi = await usersProviders.getWallet(jwtToken);
        coincontroller.myBlance.value =
            WalletModel.fromJson(responseApi.data).balance;
        await Stripe.instance.presentPaymentSheet().then((value) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            Text("Payment Successfull"),
                          ],
                        ),
                      ],
                    ),
                  ));
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

          paymentIntent = null;
        }).onError((error, stackTrace) {
          print('Error is:--->$error $stackTrace');
        });
      }
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': 'vnd',
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51MlkNYAQ4iPCTQCcJ9iLbs09DZHYbJDvmdjZwllmsi75Ph6vSnTgqzS5zP0kR2it1gtZBtFTr4JTVbwBWeEEVOAI00WiTU1rZM',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 1000;
    return calculatedAmout.toString();
  }

  // Future<Map<String, dynamic>> createPaymentIntent(
  //     String amount, String jwtToken) async {
  //   try {
  //     Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/payment/top-up');
  //     final Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $jwtToken',
  //     };
  //     final Map<String, dynamic> body = {
  //       'amount': int.parse(amount),
  //     };
  //     final http.Response response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     }
  //     // Handle the response from the API
  //     if (response.statusCode != 200) {
  //       Get.snackbar("Fail", "Server error");
  //     }
  //   } catch (err) {
  //     // ignore: avoid_print
  //     print('err charging user: ${err.toString()}');
  //   }
  // }

  // createPaymentIntent(String amount) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': 'USD',
  //       'payment_method_types[]': 'card'
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization':
  //             'Bearer sk_test_51MhPNdHEQq2FcNkbC8FWVHxoCoGsST8apsyzartX4LgBvbGgDdwOGoYtiOQ4J8UjGCXzDhJFFrDj1pUtFbOyc6PQ00cUOiVWYL',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     // ignore: avoid_print
  //     print('Payment Intent Body->>> ${response.body.toString()}');
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     // ignore: avoid_print
  //     print('err charging user: ${err.toString()}');
  //   }
  // }

  // Future<void> makePayment(BuildContext context, String amount) async {
  //   String? jwtToken = await storage.read(key: 'jwtToken');
  //   if (jwtToken != null) {
  //     Map<String, dynamic> paymentIntentData = await payment(amount, jwtToken);
  //     print('paymentIntent $paymentIntentData');
  //     if (paymentIntentData['paymentIntent'] != "" &&
  //         paymentIntentData['paymentIntent'] != null) {
  //       String intent = paymentIntentData['paymentIntent'];
  //       await Stripe.instance
  //           .initPaymentSheet(
  //               paymentSheetParameters: SetupPaymentSheetParameters(
  //                   paymentIntentClientSecret: intent,
  //                   style: ThemeMode.dark,
  //                   merchantDisplayName: 'Adnan'))
  //           .then((value) {});

  //       await Stripe.instance.presentPaymentSheet();
  //     }
  //   }
  // }

  // payment(String amount, String jwtToken) async {
  //   try {
  //     Uri uri = Uri.http(Environment.API_URL_OLD, '/api/v1/payment/top-up');
  //     final Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $jwtToken',
  //     };
  //     final Map<String, dynamic> body = {
  //       'amount': int.parse(amount),
  //     };
  //     final http.Response response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     }
  //     // Handle the response from the API
  //     if (response.statusCode != 200) {
  //       Get.snackbar("Fail", "Server error");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Fail", "You can not payment");
  //   }
  // }
}
