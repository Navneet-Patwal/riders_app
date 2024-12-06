import 'package:flutter/material.dart';
import 'package:riders_app/view/authscreens/signin_screen.dart';
import 'package:riders_app/view/authscreens/signup_screen.dart';



class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _authScreenState();
}

class _authScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Vegie",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock,color: Colors.white),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person,color: Colors.white),
                text: "Register",
              )
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5,
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: const TabBarView(
            children: [
              SignInScreen(),
              SignupScreen()
            ],
          ),
        ),
      ),
    );
  }
}
