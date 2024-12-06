import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authscreens/auth_screen.dart';
import '../mainscreen/home_screen.dart';


class mySplashScreen extends StatefulWidget {
  const mySplashScreen({super.key});

  @override
  State<mySplashScreen> createState() => _mySplashScreenState();
}

class _mySplashScreenState extends State<mySplashScreen> {
  initTimer(){

    Timer(const Duration(seconds: 3),() async
    {
      if( FirebaseAuth.instance.currentUser == null){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>AuthScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
      }

    });
  }

  @override

  void initState(){
    super.initState();

    initTimer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "images/splash.webp"
              ),
            ),
            const Text(
              "Rider's App",
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 26,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }
}
