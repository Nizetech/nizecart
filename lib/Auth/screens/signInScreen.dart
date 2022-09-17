import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Auth/screens/signUp_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../botton_nav.dart';
import 'forgetPaassword.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final LocalAuthentication auth = LocalAuthentication();

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


// Finger Print
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  // Future<void> _getAvailableBiometrics() async {
  //   List<BiometricType> availableBiometrics;
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     availableBiometrics = <BiometricType>[];
  //     print(e);
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _availableBiometrics = availableBiometrics;
  //   });
  // }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason:
  //           'Scan your fingerprint (or face or whatever) to authenticate',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Authenticating';
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';
  //   setState(() {
  //     _authorized = message;
  //   });
  // }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
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
                SizedBox(height: 10),
                IconButton(
                    onPressed: _authenticate,
                    icon: Icon(
                      Icons.fingerprint,
                      color: mainColor,
                      size: 40,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
