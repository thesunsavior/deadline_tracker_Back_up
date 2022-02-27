import 'package:deadline_tracker/Screens/Sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deadline_tracker/Screens/Home.dart';

class ScreenDirector extends StatelessWidget {
  const ScreenDirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null)
      return SignInScreen();
    else return HomeScreen();
  }
}
