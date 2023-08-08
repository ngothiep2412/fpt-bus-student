import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppBarContainerController extends GetxController {
  void removeALl() {
    GetStorage().remove('trip');
    GetStorage().remove('tripDetail');
    GetStorage().remove('routeDetail');
    // if (GetStorage().hasData('ticketComming')) {
    //   GetStorage().remove('noTicketComing');
    // }

    Get.offAndToNamed('/navigation');
  }
}
