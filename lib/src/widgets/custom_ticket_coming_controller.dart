import 'dart:async';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/global/global.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/providers/ticket_provider.dart';
import 'package:fbus_app/src/providers/trips_provider.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CustomTicketComingController extends GetxController {
  TicketProviders ticketProviders = TicketProviders();
  TripProviders tripProviders = TripProviders();
  FlutterSecureStorage storage = FlutterSecureStorage();
  UsersProviders usersProviders = UsersProviders();
  // HomeController homeController = Get.find();

  Timer? _timer;
  int? seconds;
  String? routeName;
  int remainingSeconds = 1;
  final time = '00.00'.obs;
  bool shouldStopTimer = false; // Đặt biến cờ thành giá trị mặc định

  @override
  void onReady() {
    _startTimer(seconds! + 60);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  void signOut() async {
    GetStorage().erase();
    await storage.deleteAll();
    fAuth.signOut();
    await googleSignIn.signOut();
    Get.offNamedUntil('/splash', (route) => false);
  }

  // This function is designed for pushing notifications.
  pushNotification(String title, String body) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    String? fireToken = await storage.read(key: 'firebaseToken');
    if (jwtToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      int expirationTimestamp = decodedToken['exp'] * 1000;
      if (DateTime.now().millisecondsSinceEpoch > expirationTimestamp) {
        signOut();
      }
    }

    try {
      usersProviders.uploadNotification(fireToken!, title, body, jwtToken!);
    } catch (err) {
      // Show a SnackBar with the error message
      Get.snackbar('Error', 'Failed to upload notification');

      // Navigate to the Home page
      // Get.offAllNamed('/navigation');
    }
  }

  void goToTicketDetail(String ticketId, BuildContext context) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
      max: 200,
      msg: 'Loading.....',
      progressValueColor: Colors.white,
      progressBgColor: AppColor.orange,
      // msgColor: Colors.black,
    );
    if (jwtToken != null) {
      try {
        ResponseApi responseApi =
            await usersProviders.getMyTicketDetail(jwtToken, ticketId);
        final dataTicket = responseApi.data;
        progressDialog.close();
        if (GetStorage().hasData('myTicketDetail')) {
          GetStorage().remove('myTicketDetail');
        }
        GetStorage().write('myTicketDetail', dataTicket);

        Get.toNamed('/more/my_ticket/my_ticket_detail');
      } catch (e) {
        Get.snackbar("ERROR", "SERVER");
      }
    }
  }

  _startTimer(int seconds) async {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    // String? jwtToken = await storage.read(key: 'jwtToken');
    // ResponseApi? responseApiTicket;
    // ResponseApi? responseApiTrip;

    // if (jwtToken != null) {
    //   responseApiTicket = await ticketProviders.getTicketComming(jwtToken);
    //   responseApiTrip = await tripProviders.getListTripToday(jwtToken);
    // }
    print('Seconds: $seconds');

    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 300) {
        pushNotification("PLease check in",
            "Your trip named $routeName is scheduled to begin in 5 minutes!");
      }
      if (remainingSeconds == 0) {
        // if (GetStorage().hasData('ticketComming')) {
        //   GetStorage().remove('ticketComming');
        // }
        // if (GetStorage().hasData('noTicketComing')) {
        //   GetStorage().remove('noTicketComing');
        // }

        // get Ticket Coming
        // if (responseApiTicket!.message == "No trip found") {
        //   GetStorage().write('noTicketComing', responseApiTicket.message);
        // } else if (responseApiTicket.data != null) {
        //   GetStorage().write('ticketComming', responseApiTicket.data);
        // }
        // get Today Trip
        // final data = responseApiTrip!.data;
        // if (GetStorage().hasData('tripListToday')) {
        //   GetStorage().remove('tripListToday');
        // }
        // GetStorage().write('tripListToday', data);

        // homeController.ticketComing.value = TicketComingModel.fromJson(
        //     GetStorage().read('ticketComming') ?? {});
        // homeController.tripListToday = GetStorage().read('tripListToday');
        pushNotification(
            "Time Up!!!", "Your trip named $routeName is about to begin!");
        timer.cancel();
        // Get.offAndToNamed('/navigation');
        Get.offNamedUntil('/navigation', (route) => false);
      } else {
        int hours = remainingSeconds ~/ 3600;
        int minutes = (remainingSeconds % 3600) ~/ 60;
        int seconds = remainingSeconds % 60;
        time.value =
            "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingSeconds--;
      }
    });
  }
}
