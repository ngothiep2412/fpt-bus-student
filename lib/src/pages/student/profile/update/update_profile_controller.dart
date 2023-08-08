import 'dart:io';
import 'dart:convert';
import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/models/response_api.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:fbus_app/src/pages/student/home/home_controller.dart';
import 'package:fbus_app/src/pages/student/profile/info/profile_controller.dart';
import 'package:fbus_app/src/pages/student/searchTrip/search_trip_controller.dart';
import 'package:fbus_app/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class UpdateProfileController extends GetxController {
  FlutterSecureStorage storage = FlutterSecureStorage();

  UserModel user = UserModel.fromJson(GetStorage().read('user') ?? {});
  var informationUser = UserModel.fromJson(GetStorage().read('user') ?? {}).obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ProfileController profileController = Get.find();
  HomeController homeController = Get.find();
  SearchTripController searchTripController = Get.find();
  UpdateProfileController() {
    nameController.text = informationUser.value.fullname ?? '';
    phoneController.text = informationUser.value.phoneNumber ?? '';
  }

  final RegExp phoneExp = RegExp(r'^[0-9]+$');

  ImagePicker picker = ImagePicker();
  File? imageFile;
  UsersProviders usersProviders = UsersProviders();
  void updateInfo(BuildContext context) async {
    String name = nameController.text;
    String phone = phoneController.text;
    if (phone.isEmpty) {
      phone = '';
    }
    if (isValidForm(name, phone)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(
        max: 200,
        msg: 'Updating data...',
        progressValueColor: Colors.white,
        progressBgColor: AppColor.orange,
        // msgColor: Colors.black,
      );
      try {
        String? jwtToken = await storage.read(key: 'jwtToken');
        if (jwtToken != null) {
          if (imageFile == null) {
            ResponseApi responseApi = await usersProviders
                .updateProfileWithoutPicture(name, phone, jwtToken, user);
            final dataUser = responseApi.data;
            if (dataUser != null) {
              profileController.user.value =
                  UserModel.fromJson(responseApi.data);
              searchTripController.user.value =
                  UserModel.fromJson(responseApi.data);
              homeController.user.value = UserModel.fromJson(responseApi.data);
              if (GetStorage().hasData('user')) {
                GetStorage().remove('user');
              }
              GetStorage().write('user', dataUser);
              progressDialog.close();
              Get.snackbar(
                  "Succesfully", "Updated your information Succesfully!");
            }
          } else {
            // String? jwtToken = await storage.read(key: 'jwtToken');
            List<int> imageBytes = await imageFile!.readAsBytes();
            String base64Image = base64Encode(imageBytes);
            // String? jwtToken = await storage.read(key: 'jwtToken');
            ResponseApi responseApifirst =
                await usersProviders.uploadPicture(user, base64Image, jwtToken);
            if (responseApifirst.data != null) {
              ResponseApi responseApi =
                  await usersProviders.updateProfilePicture(
                      responseApifirst.data['imageUrl'],
                      name,
                      phone,
                      jwtToken,
                      user);
              final dataUser = responseApi.data;

              if (responseApi.data != null) {
                profileController.user.value =
                    UserModel.fromJson(responseApi.data);
                searchTripController.user.value =
                    UserModel.fromJson(responseApi.data);
                homeController.user.value =
                    UserModel.fromJson(responseApi.data);
                if (GetStorage().hasData('user')) {
                  GetStorage().remove('user');
                }
                print('DATA UPDATED: ${dataUser}');
                GetStorage().write('user', dataUser);
                progressDialog.close();
                Get.snackbar(
                    "Succesfully", "Updated your information succesfully!");
              }
            }
          }
        }
      } catch (e) {
        Get.snackbar("Error", "Updated your information fail!");
        progressDialog.close();
      }
    }
  }

  // void updateWithImage() async {
  //   // String? jwtToken = await storage.read(key: 'jwtToken');
  //   List<int> imageBytes = await imageFile!.readAsBytes();
  //   String base64Image = base64Encode(imageBytes);
  //   print('base64Image $base64Image');
  //   final box = GetStorage();
  //   // String? jwtToken = await storage.read(key: 'jwtToken');
  //   String jwtToken = box.read('jwtToken');
  //     ResponseApi responseApi = await usersProviders.updateProfilePicture(
  //         userSession, base64Image, jwtToken);
  //     // final data = responseApi['data'];
  //     if (responseApi.data != null) {
  //       Get.snackbar("Successfully", "Updated image fully");
  //     }
  //   }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      File selectedFile = File(image.path);
      if (selectedFile.lengthSync() < 1000000 * 50) {
        imageFile = selectedFile;
        update();
      } else {
        Get.snackbar("Error", "Your image size is too large");
      }
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text(
        'Gallery',
        style: TextStyle(color: AppColor.textColor),
      ),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);
      },
      child: const Text(
        'Camera',
        style: TextStyle(color: AppColor.textColor),
      ),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text(
        'Select an option',
        style: TextStyle(color: AppColor.primary),
        textAlign: TextAlign.center,
      ),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  bool isValidForm(
    String fullname,
    String phone,
  ) {
    if (phone.isEmpty) {
      return true;
    } else {
      if (phoneExp.hasMatch(phone) == false) {
        Get.snackbar('Invalid from', 'You must enter with valid phone');
        return false;
      }
    }

    if (fullname.isEmpty) {
      Get.snackbar('Invalid from', 'You must enter number');
      return false;
    }
    return true;
  }
}
