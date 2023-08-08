import 'package:fbus_app/src/global/global.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/response_api_pagination.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MoreController extends GetxController {
  final storage = FlutterSecureStorage();
  UsersProviders usersProviders = UsersProviders();
  void signOut() async {
    GetStorage().erase();
    await storage.deleteAll();
    fAuth.signOut();
    await googleSignIn.signOut();
    Get.offNamedUntil('/splash', (route) => false);
  }

  void goToMyTicketList() async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken != null) {
      ResponseApiPagination responseApi =
          await usersProviders.getListTicket(jwtToken);
      final data = responseApi.data;
      // read existing ticketList from storage
      // Invalidate the cache for 'ticketList'
      if (GetStorage().hasData('ticketList')) {
        GetStorage().remove('tickList');
      }
      GetStorage().write('ticketList', data);
      Get.toNamed('/more/my_ticket');
    }
  }

  void goToTransactionHistory() {
    Get.toNamed('/more/transaction_history');
  }

  void goToPayment() async {
    String? jwtToken = await storage.read(key: 'jwtToken');
    if (jwtToken != null) {
      ResponseApi responseApi = await usersProviders.getWallet(jwtToken);
      final data = responseApi.data;
      // read existing ticketList from storage
      // Invalidate the cache for 'ticketList'

      if (data != null) {
        if (GetStorage().hasData('myWallet')) {
          GetStorage().remove('myWallet');
        }
        GetStorage().write('myWallet', data);
      }
      Get.toNamed('/more/my_coin');
    }
  }

  void goToAboutUs() {
    Get.toNamed('/more/about_us');
  }
}
