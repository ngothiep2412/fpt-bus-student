import 'package:fbus_app/src/models/llist_ticket_model.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyTicketDetailController extends GetxController {
  ListTicketModel ticketDetail =
      ListTicketModel.fromJson(GetStorage().read('myTicketDetail'));
  UserModel user = UserModel.fromJson(GetStorage().read('user') ?? {});
}
