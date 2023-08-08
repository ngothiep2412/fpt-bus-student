import 'package:fbus_app/src/models/ticket_model.dart';
import 'package:fbus_app/src/models/trip_model.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TicketDetailController extends GetxController {
  UserModel user = UserModel.fromJson(GetStorage().read('user') ?? {});
  TicketModel ticket = GetStorage().read('ticket');
  TripModel tripDetail = TripModel.fromJson(GetStorage().read('tripDetail'));
}
