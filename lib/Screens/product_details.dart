import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({
    Key key,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}

// import '../Widget/component.dart';

// class ProductDetails extends StatelessWidget {
//   const ProductDetails({Key  ?key}) : super(key: key);
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Details'),
//       ),
//       body: Container(
//         alignment: Alignment.center,
//         width: MediaQuery.of(context).size.width * .43,
//         margin: EdgeInsets.only(left: 10, top: 15, right: 10),
//         decoration: BoxDecoration(
//           color: white,
//           boxShadow: [
//             BoxShadow(
//               offset: Offset(0, 3),
//               blurRadius: 5,
//               color: Colors.grey.withOpacity(.5),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(15),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Image(
//             image: AssetImage(item['image']),
//             width: 140,
//             height: 120,
//             fit: BoxFit.contain,
//           ),
//           IconButton(
//             icon: item['isFav']
//                 ? Icon(Iconsax.heart5)
//                 : const Icon(Iconsax.heart),
//             onPressed: () {
//               setState(() {
//                 item['isFav'] = !item['isFav'];
//               });
//             },
//             color: mainColor,
//           ),
//           SizedBox(height: 3),
//           Text(
//             item['title'],
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: Colors.grey),
//           ),
//           SizedBox(height: 3),
//           Text(
//             '\$${item['price']}'.toString(),
//             style: const TextStyle(
//                 color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 3),
//           RatingBarIndicator(
//             rating: 2.75,
//             itemBuilder: (context, index) => const Icon(
//               Icons.star,
//               color: Colors.amber,
//             ),
//             itemCount: 5,
//             itemSize: 15,
//             direction: Axis.horizontal,
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     if (item['quantity'] > 1) {
//                       item['quantity']--;
//                       showErrorToast('Removed from Cart');
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(6),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4), color: mainColor),
//                   child: const Icon(
//                     Icons.remove,
//                     size: 18,
//                     color: white,
//                   ),
//                 ),
//               ),
//               Text(item['quantity'].toString()),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     if (item['quantity'] < 10) {
//                       item['quantity']++;
//                       showToast('Added to cart');
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(6),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4), color: mainColor),
//                   child: const Icon(
//                     Icons.add,
//                     size: 18,
//                     color: white,
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ]),
//       ),
//     );
//   }
// }
