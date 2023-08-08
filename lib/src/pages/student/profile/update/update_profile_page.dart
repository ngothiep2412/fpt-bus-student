import 'package:fbus_app/src/core/const/colors.dart';
import 'package:fbus_app/src/pages/student/profile/update/update_profile_controller.dart';
import 'package:fbus_app/src/utils/helper.dart';
import 'package:fbus_app/src/widgets/app_bar_container.dart';
import 'package:fbus_app/src/widgets/custom_form_input.dart';
import 'package:fbus_app/src/widgets/item_button_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  UpdateProfileController con = Get.put(UpdateProfileController());

  @override
  void dispose() {
    con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleString: "Update Profile",
        implementLeading: true,
        notification: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: Helper.getScreenWidth(context),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        _imageProfile(context),
                        const SizedBox(
                          height: 10,
                        ),
                        _editImage(),
                        const SizedBox(
                          height: 10,
                        ),
                        _textWelcome(),
                        const SizedBox(
                          height: 10,
                        ),
                        _textEmail(),
                        const SizedBox(
                          height: 45,
                        ),
                        CustomFormInput(
                          label: "Name",
                          isPassword: false,
                          controller: con.nameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormInput(
                          label: "Mobile No",
                          isPassword: false,
                          controller: con.phoneController,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ItemButtonWidget(
                          data: 'Update',
                          color: Colors.white,
                          onTap: () async {
                            con.updateInfo(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // *TODO
  Widget _imageProfile(BuildContext context) {
    return ClipOval(
      child: Stack(
        children: [
          Container(
            height: 80,
            width: 80,
            child: GetBuilder<UpdateProfileController>(
              builder: (value) => con.imageFile != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(con.imageFile!),
                    )
                  : con.user.profileImg != null
                      ? FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: con.user.profileImg ?? '',
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          Helper.getAssetName(
                            "user.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 20,
              width: 80,
              color: Colors.black.withOpacity(0.3),
              child: GestureDetector(
                onTap: () => con.showAlertDialog(context),
                child: Image.asset(Helper.getAssetName("camera.png")),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _editImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Helper.getAssetName("edit_filled.png"),
        ),
        const SizedBox(
          width: 5,
        ),
        const Text(
          "Edit Profile",
          style: TextStyle(color: AppColor.orange),
        ),
      ],
    );
  }

  Widget _textWelcome() {
    return const Text(
      "Welcome",
      style: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _textEmail() {
    return Text(
      "${con.user.email}",
      style: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.normal,
        fontSize: 20,
      ),
    );
  }
}
