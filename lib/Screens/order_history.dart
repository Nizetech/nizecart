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
        itemCount: 2,
        separatorBuilder: (ctx, i) => SizedBox(height: 20),
        itemBuilder: (ctx, i) {
          return Container();
        },
      ),
    );
  }
}
