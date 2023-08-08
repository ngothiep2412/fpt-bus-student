import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

FlutterSecureStorage storage = FlutterSecureStorage();

class SearchTripController extends GetxController {
  var user = UserModel.fromJson(GetStorage().read('user') ?? {}).obs;
  UsersProviders usersProviders = UsersProviders();
  final routeTextEditting = TextEditingController();
  DateTime? selectedDate;

  void searchTheTrip(BuildContext context) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (isValidForm(routeTextEditting.text, selectedDate)) {
      String date = DateFormat('yyyy-MM-dd').format(selectedDate!);
      ProgressDialog progressDialog = ProgressDialog(context: context);

      progressDialog.show(
        max: 200,
        msg: 'Searching data...',
        progressValueColor: Colors.white,
        progressBgColor: AppColor.orange,
      );
      try {
        if (jwtToken != null) {
          List<TripModel> listTrip = await usersProviders.getDataTrip(
              jwtToken, date, routeTextEditting.text);
          // routeTextEditting.text = '';
          // selectedDate = null;
          progressDialog.close();
          if (listTrip.isNotEmpty) {
            GetStorage().write('trip', listTrip);
            Get.toNamed('/navigation/search_trip/list_trip');
          }
        }
      } catch (err) {
        Get.offAllNamed('/navigation');
      }

      // Get.toNamed('/navigation/home/list-bus');
      // Get.toNamed('/navigation/home/booking-bus');
    }
  }

  // This function is designed for pushing notifications.
  void pushNotification() async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    String? fireToken = await storage.read(key: 'firebaseToken');
    try {
      usersProviders.uploadNotification(
          fireToken!, "Test notification 222", "test", jwtToken!);
    } catch (err) {
      // Show a SnackBar with the error message
      Get.snackbar('Error', 'Failed to upload notification');

      // Navigate to the Home page
      Get.offAllNamed('/navigation');
    }
  }

  bool isValidForm(String routeName, DateTime? date) {
    if (routeName.isEmpty) {
      Get.snackbar('Invalid from', 'You must enter your route');
      return false;
    } else if (date == null) {
      Get.snackbar('Invalid from', 'You must enter your date');
      return false;
    }
    return true;
  }
}
