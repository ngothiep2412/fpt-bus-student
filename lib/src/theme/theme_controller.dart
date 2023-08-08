import 'package:fbus_app/src/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    // Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    Get.changeTheme(
      _isDarkMode.value
          ? ThemeData(
              fontFamily: "Metropolis",
              scaffoldBackgroundColor: Color(0xff444654),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColor.orange,
                  ),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    AppColor.orange,
                  ),
                ),
              ),
              primaryColor: AppColor.orange,
              colorScheme: const ColorScheme(
                primary: AppColor.orange,
                secondary: Colors.amberAccent,
                brightness: Brightness.light,
                onBackground: Colors.grey,
                onPrimary: Colors.grey,
                surface: Colors.grey,
                onSurface: Colors.grey,
                error: Colors.grey,
                onError: Colors.grey,
                onSecondary: Colors.grey,
                background: Colors.grey,
              ))
          : ThemeData(
              fontFamily: "Metropolis",
              scaffoldBackgroundColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColor.orange,
                  ),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    AppColor.orange,
                  ),
                ),
              ),
              primaryColor: AppColor.orange,
              colorScheme: const ColorScheme(
                primary: AppColor.orange,
                secondary: Colors.amberAccent,
                brightness: Brightness.light,
                onBackground: Colors.grey,
                onPrimary: Colors.grey,
                surface: Colors.grey,
                onSurface: Colors.grey,
                error: Colors.grey,
                onError: Colors.grey,
                onSecondary: Colors.grey,
                background: Colors.grey,
              )),
    );
  }
}
