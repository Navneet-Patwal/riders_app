import 'package:flutter/material.dart';
import 'package:riders_app/global/global_ins.dart';
import 'package:riders_app/global/global_var.dart';
import 'package:riders_app/view/splashScreen/splash_screen.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("₹" + previousRiderEarnings,
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.black,
                  fontFamily: "Signatra"
                ),),

                const Text("Total Earnings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),),

                const SizedBox(
                  height: 20,
                    width: 200,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                ),

                const SizedBox(height: 40,),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (c)=> const mySplashScreen()));
                  },
                  child: const Card(
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 140),
                    child: ListTile(
                      leading: Icon(Icons.arrow_back,
                      color: Colors.white,),
                      title: Text(
                        "Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
