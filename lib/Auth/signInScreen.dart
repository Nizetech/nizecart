import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Auth/signUp_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../Models/productService.dart';
import '../Widget/bottonNav.dart';
import 'forgetPaassword.dart';

enum AuthMode { signup, login }

class SignInSCreen extends StatefulWidget {
  SignInSCreen({Key key}) : super(key: key);

  @override
  State<SignInSCreen> createState() => _SignInSCreenState();
}

class _SignInSCreenState extends State<SignInSCreen>
    with SingleTickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  AuthMode authMode = AuthMode.login;
  // final Map<String, String>
  FocusNode emailFocusNode = FocusNode();
  FocusNode pwdFocusNode = FocusNode();

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/NIZECART.png',
                  height: 42,
                  width: 160,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 50),
                const Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: email,
                  cursorColor: mainColor,
                  focusNode: emailFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Email address..',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,
                    prefixIcon: Icon(Iconsax.sms),
                    prefixIconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                  onSaved: (value) {
                    if (email.text.isEmpty || !email.text.contains('@')) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                    controller: pwd,
                    obscureText: isVisible,
                    obscuringCharacter: '*',
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility,
                          color: isVisible ? Colors.grey : mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                      hintText: 'Password',
                      // labelStyle: TextStyle(fontSize: 18),
                      filled: true,
                      isDense: true,
                      prefixIcon: Icon(Iconsax.lock),
                      prefixIconColor: mainColor,
                      iconColor: mainColor,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    )),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: (() => Get.to(ForgetPassword())),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xff3633be),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          loading('Logging in...');
                          bool logged =
                              await ProductService().signInWithGoogle();

                          if (logged) {
                            Hive.box('name').put('logged', true);
                            Get.offAll(BottomNav());
                          } else {
                            Get.back();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xff4838d1),
                              width: 1,
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/google.png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xff4838d1),
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          'assets/facebook.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xff4838d1),
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Image.asset(
                          'assets/apple.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    if (email.text.isNotEmpty && pwd.text.isNotEmpty) {
                      loading('Logging In....');
                      ProductService().signIn(email.text, pwd.text).then(
                        (value) {
                          if (value) {
                            User user = FirebaseAuth.instance.currentUser;
                            user.reload().then(
                              (value) {
                                if (user.emailVerified) {
                                  Hive.box('name').put('logged', true);
                                  Get.to(BottomNav());
                                } else {
                                  Get.back();
                                  user.sendEmailVerification();
                                  showErrorToast(
                                      'please check your mail for verification link');
                                }
                              },
                            );
                          }
                        },
                      );
                    } else {
                      showErrorToast('Enter your Email and Password');
                      Get.back();
                    }
                  },
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(SignUpScreen()),
                          text: ' Create Account',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: priColor,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
