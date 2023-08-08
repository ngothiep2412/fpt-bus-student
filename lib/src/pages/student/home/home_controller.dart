import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/route_model.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:fbus_app/src/providers/trips_provider.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class HomeController extends GetxController {
  FlutterSecureStorage storage = FlutterSecureStorage();
  TripProviders tripProviders = TripProviders();
  UsersProviders usersProviders = UsersProviders();

  var user = UserModel.fromJson(GetStorage().read('user') ?? {}).obs;
  // var tripListToday = GetStorage().read('tripListToday');
  // var noTicketComing = GetStorage().read('noTicketComing');
  // List<dynamic> rawList = GetStorage().read('tripListToday');
  // var ticketComing =
  //     TicketComingModel.fromJson(GetStorage().read('ticketComming') ?? {}).obs;
  // ListTicketModel ticketComming =
  //     ListTicketModel.fromJson((GetStorage().read('ticketComming'))['ticket']);

  void getTripDetail(BuildContext context, String tripId) async {
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
      print('TripID : $tripId');
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
      if (GetStorage().hasData('tripDetailID')) {
        GetStorage().remove('tripDetailID');
      }
      if (GetStorage().hasData('routeDetail')) {
        GetStorage().remove('routeDetail');
      }

      if (GetStorage().hasData('ticketQuantity')) {
        GetStorage().remove('ticketQuantity');
      }
      GetStorage().write('tripDetailID', dataTrip[0]['id']);
      GetStorage().write('tripDetail', dataTrip[0]);
      GetStorage().write('routeDetail', routeModel);
      GetStorage().write('ticketQuantity', dataTrip[0]['ticket_quantity']);

      Get.toNamed('/navigation/home/trip_detail');
    }
  }
}
