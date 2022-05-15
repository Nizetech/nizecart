import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController num = TextEditingController();

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
              TextFormField(
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
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: pwd,
                obscureText: true,
                obscuringCharacter: '*',
                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: 'Password',
                  // labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Iconsax.lock),
                  prefixIconColor: mainColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextField(
                  controller: num,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                onPressed: () => Get.to(BottomNav()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
