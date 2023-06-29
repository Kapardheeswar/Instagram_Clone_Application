import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_app/resources/auth_methods.dart';
import 'package:insta_app/screens/login_screen.dart';
import 'package:insta_app/utils/utils.dart';

import 'mobile_layout_screen.dart';

import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  Uint8List? image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      email: emailController.text,
      password: passwordController.text,
      bio: bioController.text,
      username: usernameController.text,
      file: image!,
    );
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
  Widget build(BuildContext context) {
    var keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(8, 8, 8, keyBoardSpace + 8),
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
                  Stack(
                    children: [
                      image != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(image!),
                              radius: 65,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://i.stack.imgur.com/l60Hf.png",
                              ),
                              radius: 65,
                            ),
                      Positioned(
                        left: 90,
                        top: 90,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: usernameController,
                    textInputType: TextInputType.text,
                    hintText: "Enter Your Username",
                    isPassword: false,
                    labelText: "Username",
                  ),
                  const SizedBox(
                    height: 20,
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
                  TextFieldInput(
                    textEditingController: bioController,
                    textInputType: TextInputType.text,
                    hintText: "Enter Your Bio",
                    isPassword: false,
                    labelText: "Bio",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: _isLoading == true
                          ? CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
