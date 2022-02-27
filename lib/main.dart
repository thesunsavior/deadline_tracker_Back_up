import 'package:deadline_tracker/Screens/Director.dart';
import 'package:deadline_tracker/Service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MaterialApp(home: App(),));

}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, AsyncSnapshot snapshot){
          //error
          if (snapshot.hasError){
            print ("Damn sthing goes wrong with gg");
          }

          if (snapshot.connectionState == ConnectionState.done)
            return
              StreamProvider.value(
                value: AuthService().loginState,
                initialData: null,
                child:  MaterialApp(home: ScreenDirector(),),
              );
          else
            return MaterialApp(
              home: Scaffold(
                body: CircularProgressIndicator(),
              ),
            );
        }
    );
  }
}

