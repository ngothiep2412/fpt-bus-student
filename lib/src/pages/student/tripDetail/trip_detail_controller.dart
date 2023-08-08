import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/models/route_model.dart';
import 'package:fbus_app/src/models/ticket_booking_model.dart';
import 'package:fbus_app/src/models/ticket_model.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/providers/ticket_provider.dart';
import 'package:fbus_app/src/providers/trips_provider.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

FlutterSecureStorage storage = FlutterSecureStorage();
TicketProviders ticketProviders = TicketProviders();
TripProviders tripProviders = TripProviders();

class TripDetailController extends GetxController {
  UsersProviders usersProviders = UsersProviders();
  TicketProviders ticketProviders = TicketProviders();
  RouteModel routeDetail = GetStorage().read('routeDetail');
  TripModel tripDetail = TripModel.fromJson(GetStorage().read('tripDetail'));
  // HomeController homeController = Get.find();

  void bookATrip(BuildContext context) async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken != null) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(
        max: 200,
        msg: 'Booking.....',
        progressValueColor: Colors.white,
        progressBgColor: AppColor.orange,
        // msgColor: Colors.black,
      );
      try {
        String? tripID = GetStorage().read('tripDetailID');
        if (tripID != null) {
          TicketBookingModel ticket =
              await usersProviders.getTicket(jwtToken, tripID);
          if (ticket != null) {
            progressDialog.close();
            TicketModel ticketDetail = await ticketProviders.getMyTicketDetail(
                jwtToken, ticket.ticketId);
            String tripId = "TRIP_${tripDetail.id}";
            await usersProviders.subScribeToTopic(tripId);

            // if (GetStorage().hasData('ticketComming')) {
            //   GetStorage().remove('ticketComming');
            // }
            // if (GetStorage().hasData('noTicketComing')) {
            //   GetStorage().remove('noTicketComing');
            // }

            // ResponseApi responseApiTicket =
            //     await ticketProviders.getTicketComming(jwtToken);
            // ResponseApi responseApiTrip =
            //     await tripProviders.getListTripToday(jwtToken);

            // get Ticket Coming
            // if (responseApiTicket.message == "No trip found") {
            //   GetStorage().write('noTicketComing', "responseApiTicket.message");
            // } else if (responseApiTicket.data != null) {
            //   print('Ticket Coming: ${responseApiTicket.data}');
            //   GetStorage().write('ticketComming', responseApiTicket.data);
            // }
            // get Today Trip
            // if (GetStorage().hasData('tripListToday')) {
            //   GetStorage().remove('tripListToday');
            // }
            // GetStorage().write('tripListToday', responseApiTrip.data);

            // homeController.ticketComing.value =
            //     TicketComingModel.fromJson(GetStorage().read('ticketComming'));
            // homeController.tripListToday = GetStorage().read('tripListToday');
            GetStorage().remove('tripDetailID');

            if (GetStorage().hasData('ticket')) {
              GetStorage().remove('ticket');
            }
            GetStorage().write('ticket', ticketDetail);
            progressDialog.close();
            Fluttertoast.showToast(
              msg: 'Booking successfully.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColor.busdetailColor,
              textColor: Colors.white,
            );
            Get.toNamed('/navigation/search_trip/trip_detail/booking');
            // }
          }
        }
      } catch (e) {
        progressDialog.close();
        Fluttertoast.showToast(
          msg: 'Booking fail.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColor.busdetailColor,
          textColor: Colors.white,
        );
      }
    }
  }
}
