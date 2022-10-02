import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/botton_nav.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'assets/Success_img.png',
              height: 162,
              width: 172,
            ),
            SizedBox(height: 30),
            Text(
              'Congrats!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: mainColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You have succesfully placed your order!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: CustomButton(
                text: 'Done',
                onPressed: () => Get.to(
                  BottomNav(),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
