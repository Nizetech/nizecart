import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nizecart/Widget/component.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        backgroundColor: secColor,
        elevation: 0,
        title: Text(
          'PrivacyPolicy',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: white,
          ),
        ),
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: const [
            SizedBox(height: 20),
            Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
