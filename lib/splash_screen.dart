import 'package:flutter/material.dart';
import 'package:score_snap/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    });

    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          child: Image(
            image: AssetImage('assets/images/appIcon.png'),
          ),
        ),
      ),
    );
  }
}
