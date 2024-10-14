import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:score_snap/home_page.dart';
import 'package:score_snap/sheet.dart';
import 'package:score_snap/splash_screen.dart';

void main() async {
  try {
    await _initializePrefs();
  } catch (e) {
    debugPrint(e.toString());
  }
  runApp(const MyApp());
}

Future<void> _initializePrefs() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SheetApi.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Scan',
      theme: ThemeData(
        fontFamily: "Roboto",
        backgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepOrange.shade300))),
        appBarTheme: AppBarTheme(color: Colors.deepOrange.shade300),
        primaryColor: Colors.deepOrange.shade300,
        primarySwatch: Colors.orange,
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            backgroundColor: Colors.orange.shade800,
            shape: ShapeBorder.lerp(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)), const StadiumBorder(), 0.2)!,
            width: 200,
            behavior: SnackBarBehavior.floating,
            content: Text('Double tap to exit app', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
            duration: const Duration(seconds: 1),
          ),
          child: SplashScreen(),
        ),
      ),
    );
  }
}
