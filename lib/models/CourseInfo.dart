import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class WorkDay {
  String DatePeriod="";
  TimeOfDay Stime = TimeOfDay.now();
  TimeOfDay Etime = TimeOfDay.now();
  WorkDay ({required this.DatePeriod,required this.Stime,required this.Etime});

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

  WorkDay.FromJson(Map<String, dynamic> json){
      DatePeriod = json['DatePeriod'];
      Stime      = TimeOfDay(hour:json['Stime'].toDate().hour,minute: json['Stime'].toDate().minute);
      Etime      =  TimeOfDay(hour:json['Etime'].toDate().hour,minute: json['Etime'].toDate().minute);
  }

  Map<String, dynamic> toJson(){
        return {
          'DatePeriod' : DatePeriod,
          'Stime' : DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,Stime.hour,Stime.minute),
          'Etime' : DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,Etime.hour,Etime.minute),
        };
  }

  int compareTime(TimeOfDay t1,TimeOfDay t2){
     //hour
      if (t1.hour < t2.hour)
        return -1;
      if (t1.hour > t2.hour)
        return 1 ;
      // minute
      if (t1.minute < t2.minute)
        return -1 ;
      if (t1.minute > t2.minute)
        return 1;

      return 0 ;
  }

  int WorkDayCol (WorkDay t2 ) {
    // 1 is COL , 0 is not
    if (this.DatePeriod == t2.DatePeriod){
        if (compareTime(this.Stime, t2.Etime) == 1 || compareTime(this.Etime, t2.Stime) == -1)
          return 1 ;
    }
    return 0;
  }

}

class Course {
  String Name ="";
  DateTime Sdate = DateTime.now();
  DateTime Edate = DateTime.now();
  List<WorkDay> schedule = [];
  Course ({required this.Name,required this.Sdate,required this.Edate,required this.schedule});

  Course.FromJson (Map<String, dynamic> json){
      Name      = json['Name'];
      Sdate     = json['Sdate'].toDate();
      Edate     = json['Edate'].toDate();
      schedule  = json['schedule'].map<WorkDay>((e) => WorkDay.FromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'Name' : Name,
      'Sdate': Sdate,
      'Edate': Edate,
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }

  bool CkColision (Course other){
    for( int i = 0 ; i <= schedule.length;i++){
        for (int j = 0 ;j <= other.schedule.length;j++){
            if (schedule[i].WorkDayCol(other.schedule[j]) == 1)
              return true ;
        }
    }
    return false ;
  }
}

class DeadLine{
  String Title ="";
  String fromCourse ="";
  DateTime DueDate = DateTime.now();
  DeadLine({required this.Title,required this.fromCourse, required this.DueDate});

  DeadLine.FromJson (Map<String, dynamic> json){
      Title      = json['Title'];
      fromCourse = json['fromCourse'];
      DueDate    = json['DueDate'].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      'Title'     : Title,
      'fromCourse': fromCourse,
      'DueDate'   : DueDate,
    };
  }
}

class Exam {
  String Title ="";
  String fromCourse ="";
  DateTime ExamDate = DateTime.now();
  Exam({required this.Title,required this.fromCourse, required this.ExamDate});

  Exam.FromJson (Map<String, dynamic> json){
    Title      = json['Title'];
    fromCourse = json['fromCourse'];
    ExamDate   = json['DueDate'].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      'Title'     : Title,
      'fromCourse': fromCourse,
      'DueDate'   : ExamDate,
    };
  }
}

class Activities {
  DateTime StartTime= DateTime.now();
  DateTime EndTime = DateTime.now();
  String Title = "";
  Color colors = Colors.white;
  String type = "";
  String DueTime( Activities x) {
    if (x.type == "Course"){
       return "From ${DateFormat('hh:mm').format(x.StartTime)} to ${DateFormat('hh:mm').format(x.EndTime)}";
    }
    if (x.type == "Deadline")
      return "Due at ${DateFormat('hh:mm').format(x.StartTime)}";

    return "At ${DateFormat('hh:mm').format(x.StartTime)}";
  }

  Activities({required this.Title,required this.type,required this.StartTime,required this.EndTime, required this.colors});
  DateTime join (DateTime Date, TimeOfDay time){
    return DateTime(Date.year,Date.month,Date.day,time.hour,time.minute);
  }

    Activities.fromDeadLine(DeadLine x){
    Title = "${x.Title} in ${x.fromCourse}";type= "Deadline";StartTime= x.DueDate; EndTime= x.DueDate.add(Duration(minutes: 1)); colors= Colors.red.shade700;
}

    Activities.fromExam(Exam x){
    Title= "${x.Title} in ${x.fromCourse}"; type= "Exam"; StartTime= x.ExamDate;EndTime= x.ExamDate.add(Duration(minutes: 1)); colors= Colors.redAccent.shade700;
  }
}

