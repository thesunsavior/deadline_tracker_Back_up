import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_tracker/models/BasicUserInfo.dart';
import 'package:deadline_tracker/models/CourseInfo.dart';

class DatabaseService {
  // project storage collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference Courses = FirebaseFirestore.instance.collection('Courses');

  String uid;

  DatabaseService({required this.uid});

  UserInfo userize (DocumentSnapshot snapshot){
      return UserInfo(name: snapshot['name'], major: snapshot['major'], age: snapshot['age']);
  }

  List<Course> CourseListgetter (DocumentSnapshot snapshot){
    return snapshot['Courses'].map<Course>((e) =>Course.FromJson(e)).toList() ;
  }

  List<DeadLine> DeadLineListgetter (DocumentSnapshot snapshot){
    return snapshot['Deadline'].map<DeadLine>((e) => DeadLine.FromJson(e)).toList();
  }

  List <Exam> ExamListGetter (DocumentSnapshot snapshot){
    return snapshot['Exam'].map<Exam>((e) => Exam.FromJson(e)).toList();
  }

  Future UpdateUserData  (String name,String major,int age) async {
    try{
      return await users.doc(uid).set({
        'name':  name,
        'major': major,
        'age': age,
      });
    }catch(e){
      return e.toString();
    }
  }

  Future SetCourseData  (List<Course> x,List<DeadLine> y,List<Exam> z) async {
    try{
      return await Courses.doc(uid).set({
        'Courses': x.map((e)=> e.toJson()).toList(),
        'Deadline': y.map((e) => e.toJson()).toList(),
        'Exam' : z.map((e) => e.toJson()).toList()
      });
    }catch(e){
      return e.toString();
    }
  }

  Future UpdateDeadLineData  (List<DeadLine> x) async {
    try{
      return await Courses.doc(uid).update({
        'Deadline': x.map((e) => e.toJson()).toList()
      });
    }catch(e){
      return e.toString();
    }
  }

  Future UpdateExamData  (List<Exam> x) async {
    try{
      return await Courses.doc(uid).update({
        'Exam': x.map((e) => e.toJson()).toList()
      });
    }catch(e){
      return e.toString();
    }
  }



  Stream<List<Course>> get CourseGetter{
    print(uid);
    return Courses.doc(uid).snapshots().map(CourseListgetter);
  }

  Stream<List<DeadLine>> get DeadLineGetter {
    return  Courses.doc(uid).snapshots().map(DeadLineListgetter);
  }

  Stream <List<Exam>> get ExamGetter{
    return Courses.doc(uid).snapshots().map(ExamListGetter);
  }

  Stream<UserInfo> get BasicInfo{
    return users.doc(uid).snapshots().map(userize);
  }
}