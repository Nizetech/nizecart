import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widget/component.dart';

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({Key key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: white,
        backgroundColor: secColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: mainColor.withOpacity(.2),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Address Details',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Change',
                      style: TextStyle(
                          fontSize: 16,
                          color: priColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('fortune praise',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54)),
                  SizedBox(height: 5),
                  Text(
                    '20th street, E.D.P.A, opp. uniben main gate, off new lagos road, benin city, Edo state',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(color: Colors.grey),
                  ),
                
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
