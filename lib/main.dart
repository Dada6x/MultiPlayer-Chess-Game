import 'package:chess_game/boarding.dart';
import 'package:chess_game/game_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var debug = Logger(
    printer: PrettyPrinter(
  colors: true,
  methodCount: 0,
  errorMethodCount: 3,
  printEmojis: true,
));

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
        debugShowCheckedModeBanner: false,
        title: 'Squares Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameMenu(),
      ),
    );
  }
}






/*
!an Move 
{
  "color": "w",
  "from": "e2",
  "to": "e4",
  "flags": "b",
  "piece": "p",
  "san": "e4"
}

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