import 'dart:io';

import 'package:chess_game/core/app/controller/app_controller.dart';
import 'package:chess_game/core/app/theme/themes.dart';
import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/core/layout/screens/desktop_layout.dart';
import 'package:chess_game/core/layout/screens/mobile_layout.dart';
import 'package:chess_game/core/layout/screens/tablet_layout.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

var debug = Logger(
  printer: PrettyPrinter(
    colors: true,
    methodCount: 0,
    errorMethodCount: 3,
    printEmojis: true,
  ),
);

SharedPreferences? userPref;
bool isOffline = !Get.find<AppController>().isOffline.value;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Supabase.initialize(
    url: 'https://uowxzsxqiurvurmitizt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvd3h6c3hxaXVydnVybWl0aXp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5NzM5OTQsImV4cCI6MjA2NjU0OTk5NH0.J7_YpRoe8BhHOeDFGLboIZUqJy8PM4Mau_cKtGnt_ig',
  );

  runApp(
    DevicePreview(
      backgroundColor: accentAmber,
      isToolbarVisible: false,
      enabled: kIsWeb,
      builder: (context) => const App(),
    ),
  );
  // runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.put(AppController());

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chess Game',
              theme: appController.isDarkMode.value
                  ? Themes().darkMode
                  : Themes().lightMode,
              locale: DevicePreview.locale(context),
              builder: DevicePreview.appBuilder,
              home: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth >= 1280) {
                  debug.e("DESKTOP LAYOUT");
                  return const DesktopLayout();
                } else if (constraints.maxWidth >= 800) {
                  debug.e("Tablet LAYOUT");
                  return const TabletLayout();
                } else {
                  debug.i("Mobile LAYOUT");
                  return const MobileLayout();
                }
              })),
        );
      },
    );
  }
}
