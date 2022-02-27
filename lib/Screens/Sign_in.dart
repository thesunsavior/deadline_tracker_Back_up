import 'package:flutter/material.dart';
import 'package:deadline_tracker/ColorPicker.dart';
import 'Form/SignInForm.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPicker().appBarColor,
          title: Center (
              child: Text("Sign in ")
          ),
        ),
        body:
          ListView(
            padding: EdgeInsets.symmetric(vertical:5, horizontal: 20.0),
              children: [
                Image(
                  image: ResizeImage(AssetImage('Assest/Logo.png'), width: 600,height:400),
                ),
                SignInForm(),
              ],
            ),
          );
  }
}
