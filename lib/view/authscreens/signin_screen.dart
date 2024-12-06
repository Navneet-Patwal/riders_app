import 'package:flutter/material.dart';


import '../../global/global_ins.dart';
import '../widgets/custom_text_feild.dart';




class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _signinScreenState();
}

class _signinScreenState extends State<SignInScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/logo.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  textEditingController: emailEditingController,
                  iconData: Icons.email,
                  hintString: "Email",
                  isObscure: false,
                  enabled: true,
                ),
                CustomTextField(
                  textEditingController: passwordEditingController,
                  iconData: Icons.lock,
                  hintString: "Password",
                  isObscure: true,
                  enabled: true,
                ),

                ElevatedButton(
                  onPressed: ()
                  {
                   authViewModel.validateSignInForm(
                     emailEditingController.text.trim(),
                     passwordEditingController.text.trim(),
                     context
                   );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10)
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
