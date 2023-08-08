import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/route_model.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/providers/trips_provider.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

FlutterSecureStorage storage = FlutterSecureStorage();

class TripListController extends GetxController {
  List<TripModel> trips = GetStorage().read('trip');
  UsersProviders usersProviders = UsersProviders();
  TripProviders tripProviders = TripProviders();
  var selectedTripId =
      ''.obs; // Observable variable to save the selected trip id

  void handleTripSelection(int index, BuildContext context) async {
    selectedTripId.value = trips[index].id;
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
          await tripProviders.getTripDetail(jwtToken, trips[index].id);
      final dataTrip = responseApi.data;
      String routeId = dataTrip[0]['route_id'];
      RouteModel routeModel =
          await usersProviders.getRouteDetail(jwtToken, routeId);

      progressDialog.close();
      if (GetStorage().hasData('tripDetail')) {
        GetStorage().remove('tripDetail');
      }
      GetStorage().write('tripDetailID', dataTrip[0]['id']);
      GetStorage().write('tripDetail', dataTrip[0]);
      GetStorage().write('routeDetail', routeModel);
      GetStorage().write('ticketQuantity', dataTrip[0]['ticket_quantity']);

      Get.toNamed('/navigation/search_trip/trip_detail');
    }
  }
}
