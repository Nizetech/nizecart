import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../Widget/component.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

TextEditingController search = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: white,
            size: 25,
          ),
          onPressed: () => Get.back(),
        ),
        title: SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width * .7,
          child: TextField(
              controller: search,
              obscureText: true,
              cursorColor: mainColor,
              decoration: InputDecoration(
                hintText: 'Search for a product',
                filled: true,
                isDense: true,
                suffixIcon: Expanded(
                  child: Container(
                    width: 50,
                    height: 45,
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Iconsax.search_normal,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                fillColor: Colors.white,
                prefixIconColor: mainColor,
                iconColor: mainColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
              )),
        ),
      ),
      backgroundColor: white,
      body: Container(),
    );
  }
}
