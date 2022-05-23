import 'dart:io';

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../Models/imageInput.dart';
import '../Widget/component.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print(users))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Container(
      color: Colors.white,
      child: TextButton(
        onPressed: addUser,
        child: Text(
          "Add User",
        ),
      ),
    );
  }
}

// End of File - AddUser.dart */
// This is the file add user screen.

class GetUserName extends StatelessWidget {
  final String documentId;
  const GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            return Text("Full Name: ${data['full_name']} ${data['commpany']}");
          }

          return Text("loading");
        });
  }
}

/// This is the class that will be used to display the list of users //

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  // FirebaseFirestore.instance.collection('users').get.then((QuerySnapshot querySnapshot ){
  //   querySnapshot.docs.forEach((docs){
  //     print(docs.data['full Name']);
  //   });
  //});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['full_name']),
              subtitle: Text(data['company']),
            );
          }).toList(),
        );
      },
    );
  }
}

// this is the class that will be used to display the list of users (Stream Method)//

class ManageProducts extends StatelessWidget {
  ManageProducts({Key key}) : super(key: key);

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  var box = Hive.box('name');

  File image;

  void selectImage(File image) {
    this.image = image;
  }

  // box: Hive.box('products'),
  // ignore: missing_return

  void addProduct() {
    // Create a CollectionReference called products that references the firestore collection
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    // Call the products CollectionReference to add a new product
    products
        .add({
          'title': title.text, // Apple
          'description': description.text, // A fruit
          'price': price.text, // 1.99
          'image': image.path,
        })
        //;
        // box
        //     .add( {
        //       'title': title.text, // Apple
        //       'description': description.text, // A fruit
        //       'price': price.text, // 1.99
        //     }
        //     )
        .then((value) => print(products))
        .catchError((error) => print("Failed to add product: $error"));
  }

  void initValue() {
    title.text = "";
    description.text = "";
    price.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(
              height: 45,
              child: TextField(
                  controller: title,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,

                    iconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                  )),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 45,
              child: TextField(
                  controller: description,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,

                    iconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: mainColor),
                    ),
                  )),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 45,
              width: 150,
              child: TextField(
                  controller: price,
                  cursorColor: mainColor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,
                    prefixIcon: Icon(Iconsax.dollar_circle),
                    prefixIconColor: mainColor,
                    iconColor: mainColor,

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                  )),
            ),
            SizedBox(height: 15),
            ImageInput(selectImage),
            CustomButton(
              text: "Add Product",
              onPressed: () {
                addProduct();
                initValue();
              },
            ),
          ],
        ),
      ),
    );
  }
}
