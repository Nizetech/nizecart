import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Models/productService.dart';
import 'package:nizecart/Screens/cart_screen.dart';
import 'package:nizecart/Widget/bottonNav.dart';
import '../Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/src/material/radio_list_tile.dart';

enum AuthMode { signup, login }

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  int selected = 1;

  bool enable2 = false;
  bool visibility = true;

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController phone = TextEditingController();

  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // final AuthMode authMode = AuthMode.signup;

  FocusNode lastname;
  FocusNode eml;
  FocusNode password;
  FocusNode number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: white,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a new Account',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fname,
                cursorColor: mainColor,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                // onFieldSubmitted: (
                //   FocusScope.of(context).requestFocus(lastname);
                // ),
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'First Name',
                  // labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Iconsax.user),
                  prefixIconColor: mainColor,
                  iconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
                // onFieldSubmitted: (_) {
                //   FocusScope.of(context).requestFocus(_);
                // },
              ),
              SizedBox(height: 15),
              TextField(
                controller: lname,
                cursorColor: mainColor,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  // labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Iconsax.user),
                  prefixIconColor: mainColor,
                  iconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      value: 0,
                      groupValue: selected,
                      title: Text("Male"),
                      onChanged: (value) => setState(() => selected = value),
                      activeColor: Colors.red,
                      selected: false,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      value: 1,
                      groupValue: selected,
                      title: Text("Female"),
                      onChanged: (value) => setState(
                        () => selected = value,
                      ),
                      activeColor: Colors.red,
                      selected: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: email,
                cursorColor: mainColor,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'Email address..',
                  // labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Iconsax.sms),
                  prefixIconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: pwd,
                obscureText: visibility,
                obscuringCharacter: '*',
                cursorColor: mainColor,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'Password',
                  // labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Iconsax.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visibility ? Icons.visibility_off : Icons.visibility,
                      color: visibility ? Colors.grey : mainColor,
                    ),
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                  ),
                  prefixIconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                  controller: phone,
                  cursorColor: mainColor,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,
                    prefixIcon: Icon(Iconsax.call),
                    prefixIconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  )),
              SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: enable2,
                      activeColor: mainColor,
                      onChanged: (val) {
                        setState(() {
                          enable2 = !enable2;
                        });
                      }),
                  RichText(
                      text: const TextSpan(
                          text: 'I agree with the ',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          children: [
                        TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(color: priColor, fontSize: 12))
                      ]))
                ],
              ),
              SizedBox(height: 30),
              CustomButton(
                text: 'Create',
                onPressed: () {
                  if (fname.text.isNotEmpty &&
                      lname.text.isNotEmpty &&
                      phone.text.isNotEmpty &&
                      pwd.text.isNotEmpty) {
                    if (pwd.text.length > 5) {
                      if (enable2) {
                        if (email.text.contains('@')) {
                          if (email.text.contains('.')) {
                            if (phone.text.length >= 11) {
                              loading('Loading...');
                              // showToast('Signed In Successful');
                            } else {
                              showErrorToast('phone number is not valid');
                              Get.back();
                              return;
                            }
                          } else {
                            showErrorToast('email is not valid');
                            Get.back();

                            return;
                          }
                        } else {
                          showErrorToast('email is not valid');
                          Get.back();

                          return;
                        }
                      } else {
                        showErrorToast(
                            'you must agree with the terms and conditions');
                        Get.back();
                        Get.back();

                        return;
                      }

                      ProductService()
                          .signUp(
                        displayName: fname.text,
                        lname: lname.text,
                        email: email.text,
                        pwd: pwd.text,
                        phone: phone.text,
                      )
                          .then((value) {
                        if (value) {
                          showToast('loggedIn in successfully');
                          Hive.box('name').put("isLoggedIn", true);
                          Get.to(BottomNav());
                        } else {
                          Get.back();
                          Get.back();
                          // Get.to(BottomNav());
                        }
                      });
                    } else {
                      showErrorToast('password must be at least 6 characters');
                    }
                  } else {
                    showErrorToast('Please fill all the fields');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
