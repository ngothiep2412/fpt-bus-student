import 'package:fbus_app/src/models/wallet_model.dart';
import 'package:fbus_app/src/pages/student/coin/buy_points_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CoinController extends GetxController {
  var myBlance =
      WalletModel.fromJson(GetStorage().read('myWallet') ?? {}).balance.obs;
  // var noWallet = GetStorage().read('noWallet');
  void goToBuyPoint() {
    Get.to(BuyCoinPage());
  }
}
