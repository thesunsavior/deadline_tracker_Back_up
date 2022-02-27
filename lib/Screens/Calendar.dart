import 'package:intl/intl.dart';

import 'package:deadline_tracker/models/CourseInfo.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'NaviationDrawer.dart';
import 'package:deadline_tracker/Globals.dart' as globals;

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}


class _CalendarState extends State<Calendar> {
  int TypeConvert ( String Date){
    switch(Date){
      case "Mon":
        return DateTime.monday;
      case "Tue":
        return DateTime.tuesday;
      case "Wed":
        return DateTime.wednesday;
      case "Thu":
        return  DateTime.thursday;
      case "Fri":
        return DateTime.friday;
      case "Sat":
        return DateTime.saturday;
      default:
        return DateTime.sunday;
    }
  }
  DateTime Join (DateTime x,TimeOfDay y){
    return DateTime(x.year,x.month,x.day,y.hour,y.minute);
  }

  List<Activities> getEventForDay (DateTime day){
    var events = <Activities>[];
    //check course
    for (int i = 0; i <globals.CourseList.length;i++)
        for (int j = 0 ; j < globals.CourseList[i].schedule.length; j ++)
        if (day.weekday == TypeConvert(globals.CourseList[i].schedule[j].DatePeriod)
        && day.isBefore(globals.CourseList[i].Edate) && day.isAfter(globals.CourseList[i].Sdate)
        ){
            events.add(Activities(Title: globals.CourseList[i].Name,type:"Course",StartTime: Join(day,globals.CourseList[i].schedule[j].Stime),EndTime: Join(day,globals.CourseList[i].schedule[j].Etime), colors: Colors.orange.shade800));
        }

    //check DeadLine
    for (int i = 0; i < globals.DeadLineList.length;i++)
      if(isSameDay(day, globals.DeadLineList[i].DueDate)){
          events.add(Activities.fromDeadLine(globals.DeadLineList[i]));
      }

    //check Exam
    for (int i = 0; i < globals.ExamList.length;i++)
      if(isSameDay(day, globals.ExamList[i].ExamDate)){
        events.add(Activities.fromExam(globals.ExamList[i]));
      }

    events.sort((a,b) {
      if (a.StartTime.isAfter(b.StartTime))
        return 1;
      if (b.StartTime.isAfter(a.StartTime))
        return -1;
      return 0 ;
    }
    );

    return events;
  }
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay  = DateTime.now();
  late ValueNotifier<List<Activities>> _selectedEvents;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedEvents= ValueNotifier(getEventForDay(DateTime.now()));

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Center(
              child: Text("Course Manager")
          ),
        ),
        drawer: Drawel(),
        body:Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              eventLoader: getEventForDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                    _selectedEvents = ValueNotifier(getEventForDay(selectedDay)) ;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
            child: ValueListenableBuilder<List<Activities>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                              margin: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 4.0,
                                            ),
                                          decoration: BoxDecoration(color:Colors.grey.shade300,
                                          border: Border.all(color: Colors.grey.shade900),
                                          borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: ListTile(
                                            title: Text("${value[index].Title}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text("${value[index].type}",style: TextStyle(color: value[index].colors,fontWeight: FontWeight.bold),)
                                                  ],
                                                ),
                                                Text(value[index].DueTime(value[index]),style: TextStyle (color: value[index].colors,fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                            ),
                          );
                    }
    );
              }
    )
            )
          ],
        ),
    );
  }
}
