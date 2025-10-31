import 'dart:async';
import 'package:chess_game/core/app/theme/themes.dart';
import 'package:chess_game/core/constants/utils/rawSnackBar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//! this controller manage three things theme , language , and internet connection
class AppController extends GetxController {
  RxBool isDarkMode = false.obs;
  RxBool isOffline = true.obs;

  late BuildContext context;

  // toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? Themes().darkMode : Themes().lightMode);
  }

  // change language
  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    Get.updateLocale(locale);
  }

  StreamSubscription? _internetConnectionStreamSubscription;

  void _checkInternetConnection() {
    bool isFirstCheck = true;
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          isOffline.value = true;
          if (isFirstCheck == true) {
            isFirstCheck = false;
            break;
          } else {
            showSuccessSnackbar("You're connected back");
            break;
          }
        case InternetStatus.disconnected:
          isOffline.value = false;

          if (isFirstCheck == true) {
            isFirstCheck = false;
            break;
          } else {
            showErrorSnackbar("No internet connection");

            break;
          }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
