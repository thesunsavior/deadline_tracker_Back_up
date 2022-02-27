import 'package:deadline_tracker/Screens/Form/CourseForm.dart';
import 'package:deadline_tracker/Service/DatabaseService.dart';
import 'package:deadline_tracker/models/CourseInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Globals.dart' as globals;
import 'Loading Screen.dart';
import 'NaviationDrawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CourseManagement extends StatefulWidget {
  const CourseManagement({Key? key}) : super(key: key);

  @override
  _CourseManagementState createState() => _CourseManagementState();
}
var dialogkey = GlobalKey<FormState>();
List <String> ListOfCourseName = ["Curricular"];
var loading = false ;
class _CourseManagementState extends State<CourseManagement> {


  void UpdateCourseListName(){
    ListOfCourseName.clear();
    ListOfCourseName.add("Curricular");
    for (var i = 0 ; i < globals.CourseList.length; i++){
      ListOfCourseName.add(globals.CourseList[i].Name);
    }
  }

  DateTime Join (DateTime x,TimeOfDay y){
    return DateTime(x.year,x.month,x.day,y.hour,y.minute);
  }

  @override
  Widget build(BuildContext context) {
    var  user = Provider.of<User?>(context);
//Exam form box----------------------------------------------------------------------------------------------------------------------------------
    createExamDialog(BuildContext context) async {

      String Sdp = "";
      String Title ="";
      TimeOfDay DueTime = TimeOfDay.now();
      DateTime DueDate  = DateTime.now();
      TextEditingController initDueDate = TextEditingController();
      TextEditingController initSTime = TextEditingController();

      return showDialog(context: context, builder: (context){
        return AlertDialog (
          title: Row(children: [Text ("Exam annoucnce "),Icon(Icons.doorbell,color: Colors.yellow.shade800)],),
          content:
          SizedBox(
            height: 400,
            width: 400,
            child: ListView(
              children: [
                Form(key: dialogkey ,
                  child:
                  Column(
                    children: [

                      TextFormField(
                        validator: (val) => val!.length<1? "This is required":null,
                        onChanged: (val){
                          Title = val;
                        },
                        initialValue: Title,

                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.text_snippet,color: Colors.black,),
                            labelText: "Exam title",
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

                      DropdownButtonFormField(
                        validator: (val) => val == null? "This is required" : null,
                        onChanged: (val) {
                          setState(() => Sdp = val.toString());
                        },
                        items: ListOfCourseName.map((sugar) {
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

                            DueDate = (await showDatePicker(
                              context: context,
                              initialDate: DueDate,
                              firstDate: DateTime(2018, 3, 5),
                              lastDate: DateTime(2100, 3, 5),
                              cancelText: "Cancel",
                              confirmText: "Set Date",
                            ))!;

                            initDueDate.text = (DateFormat('yyyy-MM-dd').format(DueDate));
                          });


                        },
                        child:
                        IgnorePointer(
                          child: TextFormField(
                            controller: initDueDate,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.black),
                                labelText: "Exam Date",
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

                            DueTime = (await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            ))!;

                            initSTime.text = TimeToString(DueTime);
                          });


                        },

                        child:
                        IgnorePointer(
                          child: TextFormField(
                            validator: (val) =>val == null? "This is required" :null
                            ,
                            controller: initSTime,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.timer,color: Colors.black),
                                labelText: "Exam time",
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
                                  globals.ExamList.add(Exam(Title: Title, fromCourse: Sdp, ExamDate: Join(DueDate,DueTime)));
                                  globals.ExamList.sort((a,b) {
                                    if (a.ExamDate.isAfter(b.ExamDate))
                                      return 1;
                                    if (b.ExamDate.isAfter(a.ExamDate))
                                      return -1;
                                    return 0 ;
                                  }
                                  );
                                });
                                Navigator.pop(context);
                                // Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => CourseManagement()));

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
              ],
            ),
          ),
        );
      });
    }

    //Deadline fill form box --------------------------------------------------------------------------------------------------------------
    createDialog(BuildContext context) async {

      String Sdp = "";
      String Title ="";
      TimeOfDay DueTime = TimeOfDay.now();
      DateTime DueDate  = DateTime.now();
      TextEditingController initDueDate = TextEditingController();
      TextEditingController initSTime = TextEditingController();
      return showDialog(context: context, builder: (context){
        return AlertDialog (
          title: Text ("DeadLine keeper "),
          content:
          SizedBox(
            height: 400,
            width: 400,
            child: ListView(
              children: [
                Form(key: dialogkey ,
                  child:
                  Column(
                    children: [

                      TextFormField(
                        validator: (val) => val!.length<1? "This is required":null,
                        onChanged: (val){
                          Title = val;
                        },
                        initialValue: Title,

                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.coffee,color: Colors.black,),
                            labelText: "Deadline title",
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

                      DropdownButtonFormField(
                        validator: (val) => val == null? "This is required" : null,
                        onChanged: (val) {
                          setState(() => Sdp = val.toString());
                        },
                        items: ListOfCourseName.map((sugar) {
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

                            DueDate = (await showDatePicker(
                              context: context,
                              initialDate: DueDate,
                              firstDate: DateTime(2018, 3, 5),
                              lastDate: DateTime(2100, 3, 5),
                              cancelText: "Cancel",
                              confirmText: "Set Date",
                            ))!;

                            initDueDate.text = (DateFormat('yyyy-MM-dd').format(DueDate));
                          });


                        },
                        child:
                        IgnorePointer(
                          child: TextFormField(
                            controller: initDueDate,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.black),
                                labelText: "Deadline due date",
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

                      Material(
                        child: InkWell(
                          onTap: (){

                            setState(() async {

                              DueTime = (await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              ))!;

                              initSTime.text = TimeToString(DueTime);
                            });


                          },

                          child:
                          IgnorePointer(
                            child: TextFormField(
                              validator: (val) =>val == null? "This is required" :null
                              ,
                              controller: initSTime,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.timer,color: Colors.black),
                                  labelText: "DeadLine Due Time",
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
                      ),

                      SizedBox(height: 20,),


                      Center(
                          child:
                          ElevatedButton(
                            onPressed: () {
                              if (dialogkey.currentState!.validate())
                              {

                                setState(() {
                                  globals.DeadLineList.add(DeadLine(Title: Title, fromCourse: Sdp, DueDate: Join(DueDate,DueTime)));
                                  globals.DeadLineList.sort((a,b) {
                                        if (a.DueDate.isAfter(b.DueDate))
                                          return 1;
                                        if (b.DueDate.isAfter(a.DueDate))
                                          return -1;
                                        return 0 ;
                                      }
                                  );
                                });
                                Navigator.pop(context);
                                // Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => CourseManagement()));

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
              ],
            ),
          ),
        );
      });
    }

//------------------------Main App--------------------------------------------------------------------------------------------

    return loading? Loading() : Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Center(
              child: Text("Course Manager")
          ),
        ),
        drawer: Drawel(),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade900),
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),

                padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Course manager",style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ), ),
                    ),

                    SizedBox(height: 20,),

                    Text("Current course (s)",style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ), ),

                    SizedBox(height: 5,),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade900),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: SizedBox (
                        height: 200,
                        width : 400,
                        child:

                        ListView.builder(
                            itemCount: globals.CourseList.length,
                            itemBuilder: (context,i)
                            => Card(
                              color: Colors.grey.shade200,
                              child: ListTile(
                                leading: InkWell(onTap: (){
                                  setState(() {
                                    globals.CourseList.removeAt(i);
                                  });
                                }, child: Icon(Icons.cancel,color: Colors.red,size: 40,)),
                                title: Text(globals.CourseList[i].Name,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 20),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Course Duration:"),
                                    Text("${DateFormat('yyyy-MM-dd').format(globals.CourseList[i].Sdate)} - ${DateFormat('yyyy-MM-dd').format(globals.CourseList[i].Edate)}"),

                                  ],
                                ),
                              ),
                            )
                        ),

                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CourseForm()));
                          },
                          child: Text("add",style: TextStyle (fontWeight: FontWeight.bold,fontSize: 15),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 20,),
//DeadLine track -------------------------------------------------------------------------------------------------------------
                    Text("Current Deadline (s)",style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ), ),

                    SizedBox(height: 5,),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade900),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: SizedBox (
                          height: 200,
                          width : 400,
                          child:

                          ListView.builder(
                            itemCount: globals.DeadLineList.length,
                            itemBuilder: (context,i)
                            => Card(
                              color: Colors.grey.shade200,
                              child: ListTile(
                                leading: InkWell(onTap: (){
                                  setState(() {
                                    globals.DeadLineList.removeAt(i);
                                  });
                                }, child: Icon(Icons.cancel,color: Colors.red,size: 40,)),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${globals.DeadLineList[i].Title}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                                    Text("Due on ${DateFormat('yyyy-MM-dd').format(globals.DeadLineList[i].DueDate)} ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14),),
                                    Text("At ${DateFormat('hh:mm').format(globals.DeadLineList[i].DueDate)} ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14),),
                                  ],
                                ),
                                subtitle: Text ("Course: ${globals.DeadLineList[i].fromCourse}"),
                              ),
                            ),
                          )
                      ),

                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              UpdateCourseListName();
                            });
                            createDialog(context);
                          },
                          child: Text("add",style: TextStyle (fontWeight: FontWeight.bold,fontSize: 15),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                          ),
                        )
                      ],
                    ),

// Exam track ----------------------------------------------------------------------------------------------------------------------
                    Text("Upcoming Exam (s)",style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ), ),

                    SizedBox(height: 5,),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade900),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: SizedBox (
                          height: 200,
                          width : 400,
                          child:

                          ListView.builder(
                            itemCount: globals.ExamList.length,
                            itemBuilder: (context,i)
                            => Card(
                              color: Colors.grey.shade200,
                              child: ListTile(
                                leading: InkWell(onTap: (){
                                  setState(() {
                                    globals.ExamList.removeAt(i);
                                  });
                                }, child: Icon(Icons.cancel,color: Colors.red,size: 40,)),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${globals.ExamList[i].Title}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                                    Text("Test Date: ${DateFormat('yyyy-MM-dd').format(globals.ExamList[i].ExamDate)} ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14),),
                                    Text("At ${DateFormat('hh:mm').format(globals.ExamList[i].ExamDate)} ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 14),),
                                  ],
                                ),
                                subtitle: Text ("Course: ${globals.ExamList[i].fromCourse}"),
                              ),
                            ),
                          )
                      ),

                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              UpdateCourseListName();
                            });
                            createExamDialog(context);
                          },
                          child: Text("add",style: TextStyle (fontWeight: FontWeight.bold,fontSize: 15),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                          ),
                        )
                      ],
                    ),

 // end---------------------------------------------------------------------------------------------------------------------
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true ;

                          });
                          await DatabaseService(uid: user!.uid).SetCourseData(globals.CourseList,globals.DeadLineList,globals.ExamList);
                          // await DatabaseService(uid: user.uid).UpdateDeadLineData(globals.DeadLineList);
                          setState(() {
                            loading = false ;
                          });

                        },
                        child: Text("Update",style: TextStyle (fontWeight: FontWeight.bold,fontSize: 15),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}