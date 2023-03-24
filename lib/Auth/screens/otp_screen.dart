import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/custom_nav_bar.dart';
import 'package:nizecart/main.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Widget/component.dart';

class OtpScreen extends ConsumerWidget {
  final String verificationId;
  OtpScreen({Key key, this.verificationId}) : super(key: key);
  TextEditingController otp = TextEditingController();
  static Box box = Hive.box('name');
  Map userData = box.get('userData');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(userData);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                width: 124,
              ),
              SizedBox(height: 30),
              Text(
                "We have sent an otp to ur mail Enter OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * .2),
              Text(
                "Please enter the OTP sent to “xyz@gmail.com”. ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              PinCodeTextField(
                length: 6,
                textStyle: TextStyle(color: Colors.white),
                appContext: context,
                obscureText: false,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(6),
                  fieldHeight: 48,
                  fieldWidth: 48,
                  activeFillColor: Colors.black,
                  inactiveFillColor: Colors.black,
                  activeColor: Colors.white,
                  borderWidth: 0,
                  selectedFillColor: Colors.black,
                  selectedColor: Colors.white,
                  inactiveColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                backgroundColor: Colors.transparent,
                controller: otp,
                onCompleted: (val) {
                  if (val.length == 6) {
                    ref
                        .read(authtControllerProvider)
                        .verifyOTP(verificationId: val.trim());
                  }
                },
                onChanged: (val) {},
              ),
              SizedBox(height: 40),
              CustomButton(
                text: 'Sign Up',
                onPressed: () {
                  ref
                      .read(authtControllerProvider)
                      .signUp(
                        userData['email'],
                        userData['password'],
                        userData['firstName'],
                        userData['lastName'],
                        userData['phoneNumber'],
                      )
                      .then((value) {
                    if (value) {
                      showToast('loggedIn in successfully');
                      Hive.box('name').put("isLoggedIn", true);
                      Get.to(CustomNavBar());
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
              SizedBox(height: 25),
              RichText(
                  text: TextSpan(
                      text: "Didn't receive OTP?  ",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Quicksand",
                        fontSize: 16,
                      ),
                      children: [
                    TextSpan(
                      text: "Resend",
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 24,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
