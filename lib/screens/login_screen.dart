import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_app/resources/auth_methods.dart';
import 'package:insta_app/screens/mobile_layout_screen.dart';

import 'package:insta_app/screens/SignUp_screen.dart';
import 'package:insta_app/widgets/text_field_input.dart';

import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void logInUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().LoginUsers(
        email: emailController.text, password: passwordController.text);
    print(res);
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res),
      ),
    );
    if (res == 'Success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return MobileLayout();
          },
        ),
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFieldInput(
                textEditingController: emailController,
                textInputType: TextInputType.emailAddress,
                hintText: "Enter Your Email",
                isPassword: false,
                labelText: "Email",
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                textEditingController: passwordController,
                textInputType: TextInputType.text,
                hintText: "Enter Your Password",
                isPassword: true,
                labelText: "Password",
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: logInUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)),
                  child: _isLoading == true
                      ? CircularProgressIndicator()
                      : Text("Log In"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
