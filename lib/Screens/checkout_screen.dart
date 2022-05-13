import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widget/component.dart';

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({Key key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int enable = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Category',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.withOpacity(.2),
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                          color: mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'fortune praise',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '20th street, E.D.P.A, opp. uniben main gate, off new lagos road, benin city, Edo state',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Edo ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Benin-City',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '+234 8098 09809',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey.withOpacity(.2),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(
                  value: 0,
                  groupValue: enable,
                  activeColor: mainColor,
                  onChanged: (val) {
                    setState(() {
                      enable = val;
                    });
                  },
                ),
                title: const Text(
                  'Door Delivery',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivered within 5 working days',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    RichText(
                        text: const TextSpan(
                      text: 'Delivery Fee: ',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                      children: [
                        TextSpan(
                          text: '\$10',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio(
                      value: 1,
                      groupValue: enable,
                      activeColor: mainColor,
                      onChanged: (val) {
                        setState(() {
                          enable = val;
                        });
                      },
                    ),
                    title: const Text(
                      'Pickup Station',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: const Text(
                      'Delivered within 5 working days',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Divider(
                      // thickness: 2,
                      ),
                  const Text(
                    'Select Pickup Station',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
                width: double.infinity,
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Sub Total',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$10, 109',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        enable == 0
                            ? Text(
                                'Shipping',
                                style: TextStyle(fontSize: 16),
                              )
                            : SizedBox(),
                        enable == 0
                            ? const Text(
                                '\$3, 109',
                                style: TextStyle(fontSize: 16),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 16),
                        ),
                        enable == 0
                            ? const Text(
                                '\$13, 118',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                '\$10, 109',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Proceed to Payment',
                      onPressed: () {},
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
