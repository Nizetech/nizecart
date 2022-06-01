import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  bool visibility = false;

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController phn = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthMode authMode = AuthMode.signup;

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
                  controller: phn,
                  cursorColor: mainColor,
                  keyboardType: TextInputType.phone,
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
                      phn.text.isNotEmpty &&
                      pwd.text.isNotEmpty) {
                    if (pwd.text.length > 5) {
                      if (enable2) {
                        if (email.text.contains('@')) {
                          if (email.text.contains('.')) {
                            if (phn.text.length == 11) {
                              showToast('Signed In Successful');
                            } else {
                              showErrorToast('phone number is not valid');
                              return;
                            }
                          } else {
                            showErrorToast('email is not valid');
                            return;
                          }
                        } else {
                          showErrorToast('email is not valid');
                          return;
                        }
                      } else {
                        showErrorToast(
                            'you must agree with the terms and conditions');
                        return;
                      }

                      ProductService()
                          .signUp(
                        fname: fname.text,
                        lname: lname.text,
                        email: email.text,
                        pwd: pwd.text,
                        phn: phn.text,
                      )
                          .then((value) {
                        if (value) {
                          showToast('Logged in successfully');
                          Get.to(BottomNav());
                        } else {
                          Get.back();
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
