import 'package:fbus_app/src/models/users.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var user = UserModel.fromJson(GetStorage().read('user') ?? {}).obs;

  void goToProfileUpdate() {
    Get.toNamed('/profile/update');
  }
}
