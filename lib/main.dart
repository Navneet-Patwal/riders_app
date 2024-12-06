import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riders_app/view/splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/global_var.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission){
    if(valueOfPermission){
      Permission.locationWhenInUse.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sellers App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white

      ),
      debugShowCheckedModeBanner: false,
      home: mySplashScreen(),
    );
  }
}

