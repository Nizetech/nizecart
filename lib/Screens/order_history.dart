import 'package:flutter/material.dart';

import '../Widget/component.dart';

class OrderHistory extends StatefulWidget {
  OrderHistory({Key key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Order History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: white,
      body: ListView.separated(
        itemCount: 3,
        padding: EdgeInsets.all(20),
        separatorBuilder: (ctx, i) => SizedBox(height: 20),
        itemBuilder: (ctx, i) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 3),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thanks for your order!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'assets/white_cart.png',
                      color: mainColor,
                      height: 30,
                      width: 30,
                    )
                  ],
                ),
                RichText(
                    text: const TextSpan(
                  text: 'Order No. : ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '445585665',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 20),
                const Text(
                  'ORDER SUMMARY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Items',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Shipping Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: const TextSpan(
                            text: 'Title : ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Smart Tv',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(height: 5),
                          RichText(
                              text: const TextSpan(
                            text: 'Price : ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '\$ 50.67',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(height: 5),
                          RichText(
                              text: const TextSpan(
                            text: 'Quantity : ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '2',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'N0. 10 off 19 street BDPA.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 3),
                        const Text(
                          'fortune97@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 3),
                        RichText(
                            text: const TextSpan(
                          text: 'Benin City',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 11,
                          ),
                          children: [
                            TextSpan(
                              text: ' Nigeria',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(height: 3),
                        RichText(
                            text: const TextSpan(
                          text: 'Postal Code:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 11,
                          ),
                          children: [
                            TextSpan(
                              text: ' 4545',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(height: 3),
                        RichText(
                            text: const TextSpan(
                          text: 'Track No.:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 11,
                          ),
                          children: [
                            TextSpan(
                              text: ' 65tu',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ))
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                RichText(
                    text: const TextSpan(
                  text: 'Total: ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: ' \$ 67,000',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )),
                Divider(),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: Column(
                    children: [
                      const Text(
                        'Need Help?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      const Text(
                        'For any further info. please click on this link below  to contact out amazing customer support.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
