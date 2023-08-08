import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/route_model.dart';
import 'package:fbus_app/src/providers/trips_provider.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

FlutterSecureStorage storage = FlutterSecureStorage();

class TripListTodayController extends GetxController {
  UsersProviders usersProviders = UsersProviders();
  TripProviders tripProviders = TripProviders();
  var selectedTripId =
      ''.obs; // Observable variable to save the selected trip id

  void handleTripSelection(String tripId, BuildContext context) async {
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
      ResponseApi responseApi =
          await tripProviders.getTripDetail(jwtToken, tripId);
      final dataTrip = responseApi.data;
      String routeId = dataTrip[0]['route_id'];
      print('RouteId : $routeId');

      RouteModel routeModel =
          await usersProviders.getRouteDetail(jwtToken, routeId);

      progressDialog.close();
      if (GetStorage().hasData('tripDetail')) {
        GetStorage().remove('tripDetail');
      }

      if (GetStorage().hasData('routeDetail')) {
        GetStorage().remove('routeDetail');
      }
      GetStorage().write('tripDetailID', dataTrip[0]['id']);
      GetStorage().write('tripDetail', dataTrip[0]);
      GetStorage().write('ticketQuantity', dataTrip[0]['ticket_quantity']);
      GetStorage().write('routeDetail', routeModel);
      Get.toNamed('/navigation/search_trip/trip_detail');
    }
  }
}
