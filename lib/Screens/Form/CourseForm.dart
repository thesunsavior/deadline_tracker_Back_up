import 'dart:ffi';
import 'package:deadline_tracker/Globals.dart' as globals;
import 'package:deadline_tracker/Screens/Course%20Manager.dart';
import 'package:deadline_tracker/models/CourseInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../NaviationDrawer.dart';
import 'package:flutter/foundation.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({Key? key}) : super(key: key);
  @override
  _CourseFormState createState() => _CourseFormState();
}

String TimeToString(TimeOfDay x1){
  var hour ="";
  var minute="";
  if (x1.hour < 10) hour ="0";
  if (x1.minute <10) minute = "0";
  
  hour = hour+x1.hour.toString();
  minute = minute+x1.minute.toString();
  return hour+":"+minute;
}

class _CourseFormState extends State<CourseForm> {
  DateTime Sdate = DateTime.now() ;
  DateTime Edate = DateTime.now() ;
  TextEditingController initEdate = TextEditingController();
  TextEditingController initSdate = TextEditingController();
  List <WorkDay> Periods=[];
  String CourseName = "";
  String error ="";
  //Dialog


  @override
  Widget build(BuildContext context) {
    //value
    var formkey = GlobalKey<FormState>();
    var dialogkey  = GlobalKey<FormState>();

      createDialog(BuildContext context) async {

      String Sdp = "";
      TimeOfDay STime = TimeOfDay.now();
      TimeOfDay ETime = TimeOfDay.now();
      List <String> daysOfTheWeek = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
      TextEditingController initETime = TextEditingController();
      TextEditingController initSTime = TextEditingController();
      return showDialog(context: context, builder: (context){
        return AlertDialog (
          title: Text ("Enter study section "),
          content:
          SizedBox(
            height: 319,
            width: 400,
            child: Form(key: dialogkey ,
            child:
              Column(
                  children: [

                    DropdownButtonFormField(
                      validator: (val) => val == null? "This is required" : null,
                      onChanged: (val) {
                        setState(() => Sdp = val.toString());
                      },
                      items: daysOfTheWeek.map((sugar) {
                        return DropdownMenuItem(
                          child: Text("$sugar"),
                          value: sugar,
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 20,),

                    InkWell(
                      onTap: (){

                        setState(() async {

                          STime = (await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          ))!;

                          initSTime.text = TimeToString(STime);
                        });


                      },

                      child:
                      IgnorePointer(
                        child: TextFormField(
                          validator: (val) =>val == null? "This is required" :null
                        ,
                          controller: initSTime,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.black),
                              labelText: "Period starting time",
                              labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.grey.shade800),
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                          //initialValue: initEdate.text
                        ),
                      ),

                    ),

                    SizedBox(height: 20,),

                    InkWell(
                      onTap: (){

                        setState(() async {

                          ETime = (await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          ))!;

                          initETime.text = TimeToString(ETime);
                        });


                      },

                      child:
                      IgnorePointer(
                        child: TextFormField(
                          validator: (val){
                            if(val == null) return "this is required";
                            if(STime.hour > ETime.hour ) return "Start time is after end time";

                            if (STime.hour == ETime.hour){
                              if (STime.minute >= ETime.minute)
                                return "Illegal start and end time";
                            }

                            return null;
                          },
                          controller: initETime,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.black),
                              labelText: "Period ending time",
                              labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.grey.shade800),
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                          //initialValue: initEdate.text
                        ),
                      ),

                    ),

                    SizedBox(height: 20,),

                    Center(
                        child:
                        ElevatedButton(
                          onPressed: () {
                            if (dialogkey.currentState!.validate())
                             {
                               setState(() {
                                 Periods.add(WorkDay(DatePeriod: Sdp, Stime: STime, Etime: ETime));
                               });
                               Navigator.pop(context);
                             }
                          },
                          child: Text("Submit"),
                          style:  ElevatedButton.styleFrom(
                              primary: Colors.black
                          ),
                        )
                    )
                  ],
              ),
            ),
          ),
        );
      });
    }

//------------------------------------------------------------------------------------------------------------

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Center (
              child: Text("Course Form ")
          ),
        ),
        drawer: Drawel(),
        body: ListView(
            padding: EdgeInsets.symmetric(vertical:15, horizontal: 20.0),
            children:[
            Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade900),
                borderRadius: BorderRadius.all(Radius.circular(18))
            ),
            padding: EdgeInsets.fromLTRB(18, 16, 18, 16),

            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Text("Course Register",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ), ),

                  SizedBox(height: 20,),

                  TextFormField(
                    validator: (val) => val!.length<1? "This is required":null,
                    onChanged: (val){
                        CourseName = val;
                    },
                    initialValue: CourseName,

                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.book,color: Colors.black,),
                        labelText: "Course name",
                        labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey.shade800),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),

                  SizedBox(height: 20,),

                  InkWell(
                    onTap: (){

                      setState(() async {

                        Sdate = (await showDatePicker(
                          context: context,
                          initialDate: Sdate,
                          firstDate: DateTime(2018, 3, 5),
                          lastDate: DateTime(2100, 3, 5),
                          cancelText: "Cancel",
                          confirmText: "Set Date",
                        ))!;

                        initSdate.text = (DateFormat('yyyy-MM-dd').format(Sdate));
                      });


                    },
                    child:
                    IgnorePointer(
                      child: TextFormField(
                        controller: initSdate,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.black),
                            labelText: "Course start date",
                            labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 3, color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 3, color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                        //initialValue: initEdate.text
                      ),
                    ),
                  ),

                  SizedBox(height: 20),


                     InkWell(
                       onTap: (){

                           setState(() async {

                             Edate = (await showDatePicker(
                               context: context,
                               initialDate: Edate,
                               firstDate: DateTime(2018, 3, 5),
                               lastDate: DateTime(2100, 3, 5),
                               cancelText: "Cancel",
                               confirmText: "Set Date",
                             ))!;

                             initEdate.text = (DateFormat('yyyy-MM-dd').format(Edate));
                           });


                       },
                       child:
                       IgnorePointer(
                         child: TextFormField(
                           validator: (value) => Sdate.isAfter(Edate)? "invalid end date" : null,
                           controller: initEdate,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.black),
                                labelText: "Course end date",
                                labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.grey.shade800),
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            //initialValue: initEdate.text
    ),
    ),
    ),


    SizedBox(height: 20),
    Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade900),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: SizedBox (
        height: 200,
        width : 300,
        child:

             ListView.builder(
                 itemCount: Periods.length,
                 itemBuilder: (context,i)
                 => Card(
                   color: Colors.grey.shade200,
                   child: ListTile(
                     leading: InkWell(onTap: (){
                       setState(() {
                         Periods.removeAt(i);
                       });
                     }, child: Icon(Icons.cancel,color: Colors.red,size: 40,)),
                     title: Text(Periods[i].DatePeriod,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 20),),
                     subtitle: Text("Time:${TimeToString(Periods[i].Stime)} - ${TimeToString(Periods[i].Etime)}"),
                   ),
                 )
             ),

      ),

    ),
                  Center(
                      child:
                      ElevatedButton(
                        onPressed: () {
                          createDialog(context);
                        },
                        child: Text("add"),
                        style:  ElevatedButton.styleFrom(
                            primary: Colors.black87,
                        ),
                      )
                  ),
    SizedBox(height: 20,),
    ElevatedButton(onPressed: (){
          if (formkey.currentState!.validate()){
              setState(() {
                globals.CourseList.add(Course(Name: CourseName,Sdate: Sdate,Edate: Edate,schedule: Periods));
              });
                Navigator.pop(context);
                Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CourseManagement()));

          }
    },
    child: Text("Submit"),
    style:  ElevatedButton.styleFrom(
    primary: Colors.black
    ),),
    SizedBox(height:10),
    Text(error,style: TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
                  ))
                ],
              ),
            ),
          ),
          ]
        ),
    );
  }
}
