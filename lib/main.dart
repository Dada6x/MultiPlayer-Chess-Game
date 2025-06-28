import 'package:chess_game/core/app/controller/app_controller.dart';
import 'package:chess_game/core/app/language/locale.dart';
import 'package:chess_game/presentation/game_menu/game_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:motion/motion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var debug = Logger(
    printer: PrettyPrinter(
  colors: true,
  methodCount: 0,
  errorMethodCount: 3,
  printEmojis: true,
));

SharedPreferences? userPref;
bool isOffline = !Get.find<AppController>().isOffline.value;

void main() async {
  //! motion
  WidgetsFlutterBinding.ensureInitialized();
  await Motion.instance.initialize();
  Motion.instance.setUpdateInterval(60.fps);
  //!
  Get.put(AppController());

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

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: GetMaterialApp(
        translations: MyLocale(),
        debugShowCheckedModeBanner: false,
        title: 'Chess Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameMenu(),
      ),
    );
  }
}


//! features To add
// online offline support
// move sounds
// win confetti
// lose/draw
// splash screen
// loading screen before each game
// game menu
// Boards theme
// QR code for sharing room_id
//  Localization → Multilingual support (e.g., Arabic/English).

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

/*


!chess ascii 
r n b q k b n r
p p p p p p p p
. . . . . . . .
. . . . . . . .
. . . . . . . .
. . . . . . . .
P P P P P P P P
R N B Q K B N R




!Flag
| Flag | Meaning                                               |
| ---- | ----------------------------------------------------- |
| `n`  | Normal move                                           |
| `b`  | Big pawn move (2 squares from starting rank) ← yours! |
| `e`  | En passant capture                                    |
| `c`  | Capture                                               |
| `k`  | Kingside castle                                       |
| `q`  | Queenside castle                                      |
| `p`  | Promotion (e.g. to queen)                             |

!Piece

| Letter | Piece  |
| ------ | ------ |
| `p`    | Pawn   |
| `n`    | Knight |
| `b`    | Bishop |
| `r`    | Rook   |
| `q`    | Queen  |
| `k`    | King   |

*/
