import 'package:deadline_tracker/Screens/Loading%20Screen.dart';
import 'package:deadline_tracker/Screens/NaviationDrawer.dart';
import 'package:deadline_tracker/Service/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deadline_tracker/Globals.dart' as globals;
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudyPlan extends StatefulWidget {
  const StudyPlan({Key? key}) : super(key: key);

  @override
  _StudyPlanState createState() => _StudyPlanState();
}
var loading = false ;

class _StudyPlanState extends State<StudyPlan> {
  Future UpdateInit () async {
    var userData = DatabaseService(uid: globals.UID);
    await userData.UpdateDeadLineData(globals.DeadLineList);
    await userData.UpdateExamData(globals.ExamList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false ;
    while(globals.ExamList.isNotEmpty && globals.ExamList[0].ExamDate.isBefore(DateTime.now())){
      globals.ExamList.removeAt(0);
    }

    while(globals.DeadLineList.isNotEmpty && globals.DeadLineList[0].DueDate.isBefore(DateTime.now())){
      globals.DeadLineList.removeAt(0);
    }

  }
  @override
  Widget build(BuildContext context) {
    var  user = Provider.of<User?>(context);
    var  userData = DatabaseService(uid: user!.uid);


    return FutureBuilder(
        future: UpdateInit(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) print(snapshot.error.toString());
            return loading? Loading(): Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black54,
                  title: Center(
                      child: Text("Course Manager")
                  ),
                ),
                drawer: Drawel(),
                body: ListView(
                  padding: EdgeInsets.symmetric( vertical: 10,horizontal: 10) ,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.grey.shade900),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text ("Study plan manager", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),)),

                          SizedBox(height: 20,),
// DeadLine countDown --------------------------------------------------------------------------------------------------------------------------
                          Row(
                            children: [
                              Text("Next deadline due:",style: TextStyle(color: Colors.blueGrey.shade800,fontWeight: FontWeight.w500,fontSize: 18),),
                              SizedBox(width: 10,),
                              Text(globals.DeadLineList.isNotEmpty? globals.DeadLineList[0].Title:"None",style: TextStyle(color: Colors.lightBlue.shade700,fontWeight: FontWeight.bold,fontSize: 20),),
                              Icon(Icons.timer_sharp,color: Colors.red.shade900,)
                            ],
                          ),

                          SizedBox(height: 10,),

                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255,0,0,0),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(14)),
                            ),
                            child:  Center(
                              child: globals.DeadLineList.isEmpty? Center(
                                child: Text('No current deadline',
          style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 38)
          ),
                              ) : CountdownTimer(
                                onEnd: () async {
                                  while(globals.DeadLineList.isNotEmpty && globals.DeadLineList[0].DueDate.isBefore(DateTime.now())){
                                    globals.DeadLineList.removeAt(0);
                                  }
                                  setState(() {
                                    loading = true ;
                                  });
                                  await userData.UpdateDeadLineData(globals.DeadLineList);
                                  setState(() {
                                    loading = false ;
                                  });
                                },
                                endTime: globals.DeadLineList.isNotEmpty? globals.DeadLineList[0].DueDate.millisecondsSinceEpoch+1000*30:DateTime.now().subtract(Duration(minutes: 1)).millisecondsSinceEpoch +1000*30,
                                widgetBuilder: (context, time) {
                                  if (time == null) {
                                    return Text('No current deadline',
                                        style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 36)
                                    );
                                  }
                                  return Text(
                                    ' ${time.days!= null? time.days:"00"}:${time.hours!= null?time.hours:"00"}:${time.min!= null?time.min:"00"}:${time.sec!= null?time.sec:"00"}',
                                    style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 48),
                                  );
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 20,),
//Exam Alert ------------------------------------------------------------------------------------------------------------------------
                          Wrap(
                            children: [
                              Text("Upcomin Exam:",style: TextStyle(color: Colors.blueGrey.shade800,fontWeight: FontWeight.w500,fontSize: 18),),
                              SizedBox(width: 10,),
                              Text(globals.ExamList.isNotEmpty? " ${globals.ExamList[0].Title} in ${globals.ExamList[0].fromCourse}": "None",style: TextStyle(color: Colors.lightBlue.shade700,fontWeight: FontWeight.bold,fontSize: 20),),
                              Icon(Icons.timer_sharp,color: Colors.red.shade900,)
                            ],
                          ),

                          SizedBox(height: 10,),

                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255,0,0,0),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(14)),
                            ),
                            child:  Center(
                              child: globals.ExamList.isEmpty? Text('All exam dated!!',
          style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 36)
          ) : CountdownTimer(
                                onEnd: () async {
                                  while(globals.ExamList.isNotEmpty && globals.ExamList[0].ExamDate.isBefore(DateTime.now())){
                                    globals.ExamList.removeAt(0);
                                  }
                                  setState((){
                                    loading = true ;
                                  });
                                  await userData.UpdateExamData(globals.ExamList);
                                  setState(() {
                                    loading = false ;
                                  });
                                },
                                endTime: globals.ExamList.length>0? globals.ExamList[0].ExamDate.millisecondsSinceEpoch+1000*30 : DateTime.now().subtract(Duration(minutes: 1)).millisecondsSinceEpoch +1000*30,
                                widgetBuilder: (context, time) {
                                  if (time == null) {
                                    return Text('All exam dated!!',
                                        style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 48)
                                    );
                                  }
                                  return Text(
                                    ' ${time.days!= null? time.days:"00"}:${time.hours!= null?time.hours:"00"}:${time.min!= null?time.min:"00"}:${time.sec!= null?time.sec:"00"}',
                                    style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 48),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
//DeadLine List----------------------------------------------------------------------------------------------------------------------
                          Text("Deadline List:",style: TextStyle(color: Colors.blueGrey.shade800,fontWeight: FontWeight.w500,fontSize: 18),),

                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
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
                                      leading: Icon (Icons.timer,color: Colors.red.shade700,size: 48,),
                                      trailing: Material(
                                        color:Colors.grey.shade200,
                                        child: InkWell(
                                          onTap: () async {
                                            setState((){
                                              loading = true ;
                                              globals.DeadLineList.removeAt(i);
                                            });

                                            await userData.UpdateDeadLineData(globals.DeadLineList);

                                            setState(() {
                                              loading = false ;
                                            });
                                          },
                                          child: Icon(Icons.done,color: Colors.green.shade700,size:20),
                                        ),
                                      ),
                                      title: CountdownTimer(
                                        endTime: globals.DeadLineList[i].DueDate.millisecondsSinceEpoch+1000*30,
                                        widgetBuilder: (context, time) {
                                          if (time == null) {
                                            return Text('Due!!!',
                                                style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 16)
                                            );
                                          }
                                          return Text(
                                            ' ${time.days!= null? time.days:"00"}:${time.hours!= null?time.hours:"00"}:${time.min!= null?time.min:"00"}:${time.sec!= null?time.sec:"00"}',
                                            style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 18),
                                          );
                                        },
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Title: ${globals.DeadLineList[i].Title}"),
                                          Text("Course: ${globals.DeadLineList[i].fromCourse}"),
                                        ],
                                      ),
                                    ),
                                  )
                              ),

                            ),
                          ),

                          SizedBox(height: 20),
// Exam List -----------------------------------------------------------------------------------------------------------------------------------
                          Text("Exam List:",style: TextStyle(color: Colors.blueGrey.shade800,fontWeight: FontWeight.w500,fontSize: 18),),

                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
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
                                      leading: Icon (Icons.timer,color: Colors.red.shade700,size: 38,),
                                      title: CountdownTimer(
                                        endTime: globals.ExamList[i].ExamDate.millisecondsSinceEpoch+1000*30,
                                        widgetBuilder: (context, time) {
                                          if (time == null) {
                                            return Text('Dated',
                                                style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 16)
                                            );
                                          }
                                          return Text(
                                            ' ${time.days!= null? time.days:"00"}:${time.hours!= null?time.hours:"00"}:${time.min!= null?time.min:"00"}:${time.sec!= null?time.sec:"00"}',
                                            style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.bold,fontSize: 18),
                                          );
                                        },
                                      ),
                                      subtitle:  Wrap(children: [Text("${globals.ExamList[i].Title} in ${globals.ExamList[i].fromCourse}",style: TextStyle(fontWeight: FontWeight.bold),)]),
                                    ),
                                  )
                              ),

                            ),
                          ),
                        ],
                      ),
                    )
                  ],)
            );
          }
          else return Loading();
        });

    }
}
