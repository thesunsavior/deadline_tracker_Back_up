import 'package:deadline_tracker/Screens/Calendar.dart';
import 'package:deadline_tracker/Screens/Course%20Manager.dart';
import 'package:deadline_tracker/Screens/Form/CourseForm.dart';
import 'package:deadline_tracker/Screens/Home.dart';
import 'package:deadline_tracker/Screens/StudyPlan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Drawel extends StatefulWidget {
  const Drawel({Key? key}) : super(key: key);

  @override
  _DrawelState createState() => _DrawelState();
}

class _DrawelState extends State<Drawel> {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Material(
                color: Colors.grey.shade800,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(height:48),
            ListTile(
              leading: Icon(Icons.home,color: Colors.white),
              title: Text(
                "Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),

              onTap: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            SizedBox(height:16),
            ListTile(
              leading: Icon(Icons.calendar_today_outlined,color: Colors.white),
              title: Text(
                "Calendar",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),

              onTap: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar()));
              },
            ),
            SizedBox(height:16),
            ListTile(
              leading: Icon(Icons.sticky_note_2_rounded,color: Colors.white),
              title: Text(
                "Course management",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),

              onTap: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(context, MaterialPageRoute(builder: (context) => CourseManagement()));
              },
            ),
            SizedBox(height:16),
            ListTile(
              leading: Icon(Icons.event_note_outlined,color: Colors.white),
              title: Text(
                "Study Plan",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),

              onTap: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(context, MaterialPageRoute(builder: (context) => StudyPlan()));
              },
            ),
            SizedBox(height:16),
            ListTile(
              leading: Icon(Icons.arrow_back,color: Colors.white),
              title: Text(
                "Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),

              onTap: (){Navigator.pop(context);},
            ),
          ],
        )
      ),
    );
  }
}

