import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Auth/screens/signUp_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../bottonNav.dart';
import 'forgetPaassword.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwd = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode pwdFocusNode = FocusNode();
  bool isVisible = true;

  void signInWithGoogle() {
    loading('Logging in...');
    // isLoggedIn
    // await ProductService().signInWithGoogle();
    ref.read(authtControllerProvider).signInWithGoogle().then((value) {
      if (value) {
        Hive.box('name').put('isLoggedIn', true);
        Get.offAll(BottomNav());
      } else {
        Get.back();
      }
    });
  }
  // Get.back();

  void visible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void signIn() {
    if (emailController.text.trim().isNotEmpty || pwd.text.trim().isNotEmpty) {
      loading('Logging In....');
      ref
          .read(authtControllerProvider)
          .signIn(
            emailController.text.trim(),
            pwd.text.trim(),
          )
          .then((value) {
        (value) {
          if (value) {
            Hive.box('name').put('isLoggedIn', true);

            Get.to(BottomNav());
            showToast('Login Successful');
          } else {
            showErrorToast('Invalid Email or Password');
            Get.back();
          }
        };
      });
    } else {
      showErrorToast('Enter your Email and Password');
      Get.back();
    }
  }

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
                  controller: emailController,
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
                    if (emailController.text.isEmpty ||
                        emailController.text.contains('@')) {
                      return;
                    }
                    return;
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
                          visible();
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
                        onTap: () {
                          signInWithGoogle();
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
                    signIn();
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
