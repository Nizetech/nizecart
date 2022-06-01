// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ProductOverviewScreen extends StatelessWidget {
//   ProductOverviewScreen({Key key}) : super(key: key);
//   CollectionReference products =
//       FirebaseFirestore.instance.collection('products');

//   final Stream<QuerySnapshot> productsStream =
//       FirebaseFirestore.instance.collection('products').snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Products'),
//         ),
//         body: ListView(
//           children: snapshot.data.docs.map((DocumentSnapshot document) {
//             Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//             return ListTile(
//               title: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(data['image']),
//                     radius: 30,
//                   ),
//                   Text(data['title']),
//                 ],
//               ),
//               subtitle: Text(data['description']),
//               trailing: Text(data['price'].toString()),
//             );
//           }).toList(),
//         ),
//       );
//     });
//     // ListView.builder(
//     //   itemCount: snapshot.data.docs.length,
//     //   itemBuilder: (context, index) {
//     //     return ListTile(
//     //       title: Text(snapshot.data.docs[index].data()['title']),
//     //       subtitle: Text(snapshot.data.docs[index].data()['description']),
//     //       trailing: Text(snapshot.data.docs[index].data()['price'].toString()),
//     //     );
//     //   },
//     // );
//     // },);
//     //   return Scaffold(
//     //       appBar: AppBar(title: Text('Product Overview')),
//     //       body: ListView(
//     //         children: [],
//     //       ));
//   }
// }

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Models/productService.dart';

import '../Widget/component.dart';

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // List products = [];
  // Map data;
  // String _imageUrl;

  // void initState() {
  //   super.initState();

  //   var ref = FirebaseStorage.instance.ref().child('images/image.jpg');
  //   ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
  // }

  @override
  Widget build(BuildContext context) {
    // products = Hive.box('name')
    return Scaffold(
      appBar: AppBar(
          title: Text('Products'),
          leading: IconButton(
            onPressed: (() => Get.back()),
            icon: Icon(Icons.arrow_back),
          )),
      body: FutureBuilder(
        future: Future.wait([
          ProductService().getProducts(),
          // ProductService().loadImage(),
        ]),
        // future: Hive.openBox('name'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          } else {
            return ListView.builder(
              itemCount: snapshot.data[0].length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    child: snapshot.data[0][index]['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                                snapshot.data[0][index]['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover),
                          )
                        : const Text('No Image'),
                    // Image.network(snapshot.data[0][index]['image']),
                  ),
                  title: Text(snapshot.data[0][index]['title']),
                  subtitle: Text(snapshot.data[0][index]['description']),
                  trailing: Text(snapshot.data[0][index]['price'].toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
