import 'package:chess_game/core/app/controller/app_controller.dart';
import 'package:chess_game/core/app/theme/themes.dart';
import 'package:chess_game/presentation/game_menu/game_menu.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  await Supabase.initialize(
    url: 'https://uowxzsxqiurvurmitizt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvd3h6c3hxaXVydnVybWl0aXp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5NzM5OTQsImV4cCI6MjA2NjU0OTk5NH0.J7_YpRoe8BhHOeDFGLboIZUqJy8PM4Mau_cKtGnt_ig',
  );

  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) => const App(),
    ),
  );
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
            home: const GameMenu(),
          ),
        );
      },
    );
  }
}

// make the game menu more like the design 
// make play with a friend (on the same device).but make use of the random chat Bot //! ex: withBot(go to singlePlayer(bot:true))


//! features To add
// online offline support.
// move sounds.
// win confetti for the winner only.
// add your name.
// lose/draw only showing to the winner.
// bug the confetti showing to the person who lost.
// splash screen.
// loading screen before each game.
// game menu.
// Boards theme.
// QR code for sharing room_id
// dialog exactly like the logout in my easyRent
//  Localization → Multilingual support (e.g., Arabic/English).


//@ bigg time idea from abdo.
// instead of sending the Whole FEN send just the last move in this way it will still work faster and it wont render the whole chess map 
// just the move happend 


//!!!!!!!!!!!!!!!!!!!! make it with webSocket via that indian dude 
// https://www.youtube.com/watch?v=Aut-wfXacXg
//! see the Build From the Scratch UI from this dude 
// https://www.youtube.com/watch?v=DM9E-Xz1mnU


//! 
// ! chess Logic
// dead pieces
// timer for each turn then it will pick an random move
// dispose the room after the game is finished
// leave the game
// make it wait for the other player to join

//@ later
// add authentication ,
// add usernames for each one
// add preview , people can join to see the game but they can play or move any piece
// make an point System ?? to unlock things inside the application like themes or something like that 
// you get points each time you win , against player or the AI



//#################################################
// Screen Util 
// LayoutBuilder
//Device Preview 
//pixel_perfect
