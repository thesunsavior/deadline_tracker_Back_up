import 'package:deadline_tracker/Screens/NaviationDrawer.dart';
import 'package:deadline_tracker/Service/DatabaseService.dart';
import 'package:deadline_tracker/Service/auth.dart';
import 'package:deadline_tracker/models/CourseInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deadline_tracker/Globals.dart' as globals;

import '../ColorPicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var  user = Provider.of<User?>(context);
    var  userData = DatabaseService(uid: user!.uid);
    return StreamBuilder (
      stream : userData.ExamGetter,
      builder: (BuildContext context, AsyncSnapshot<dynamic> Examsnapshot) {
        return StreamBuilder(
            stream: userData.CourseGetter,
            builder: (context,AsyncSnapshot Coursesnapshot){
              return  StreamBuilder(
                  stream: userData.DeadLineGetter,
                  builder: (context, AsyncSnapshot DeadLinesnapshot){



                    if (Coursesnapshot.hasData){
                      globals.CourseList =  Coursesnapshot.data as List<Course>;
                    }
                    else {
                      globals.CourseList =  [];
                    }

                    if (DeadLinesnapshot.hasData){
                      globals.DeadLineList =  DeadLinesnapshot.data as List<DeadLine>;
                    }
                    else {
                      globals.DeadLineList =  [];
                    }

                    if (Examsnapshot.hasData){
                      globals.ExamList =  Examsnapshot.data as List<Exam>;
                    }
                    else {
                      globals.ExamList =  [];
                    }

                    globals.UID = user.uid;

                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.black54,
                        title: Center (
                            child: Text("Home")
                        ),
                      ),
                      drawer: Drawel(),
                      body: Container(
                          padding: EdgeInsets.symmetric(vertical:30, horizontal: 20),
                          child:
                          Column(
                            children: [

                              // Image(
                              //   image: ResizeImage(AssetImage('Assest/Logo.png'), width: 300,height:200),
                              // ),

                              // SizedBox(height:20),

                              Center(child: Text("Welcome Back! Plan your study now !",
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 30),
                              )),

                              SizedBox(height:20),

                              Center(
                                child: TextButton.icon(onPressed: () {
                                  Navigator.push(context,  MaterialPageRoute(builder: (context) => Drawel()),);
                                }
                                    , icon: Icon(Icons.lightbulb,color: Colors.yellow.shade900,), label: Text(
                                      "Make a plan!",
                                      style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),
                                    )),
                              ),

                              // SizedBox(height:10),

                              Center(
                                child: TextButton.icon  (onPressed: () async {
                                  AuthService().SignOut();
                                  Navigator.popUntil(context, ModalRoute.withName('/'));
                                }
                                    , icon: Icon(Icons.wb_incandescent_outlined,color: Colors.black,), label: Text(
                                      "Log out",
                                      style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),
                                    )),
                              ),

                            ],
                          )
                      ),
                    );
                  }
              );
            }
        );
      },
    );

  }
}


