import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widget/component.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: const Text(
          'Catergory',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(color: white, boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(.2),
                )
              ]),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Grocery',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Homes & Garden',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Phones & Tablets',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Computing',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Electronics',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Fashion',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: const Text(
                      'Baby Poducts',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    title: Text(
                      'Gaming',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
