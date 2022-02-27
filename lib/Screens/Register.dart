import 'package:deadline_tracker/Screens/Form/RegisterForm.dart';
import 'package:flutter/material.dart';

import '../ColorPicker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPicker().appBarColor,
        title: Center (
            child: Text("Sign Up")
        ),
      ),
      body:
      ListView(
        padding: EdgeInsets.symmetric(vertical:5, horizontal: 20.0),
        children: [
          Image(
            image: ResizeImage(AssetImage('Assest/Logo.png'), width: 600,height:400),
          ),
            RegisterForm(),
        ],
      ),
    );
  }
}
