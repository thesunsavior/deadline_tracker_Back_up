import 'package:firebase_auth/firebase_auth.dart';
import 'DatabaseService.dart';

class AuthService{
  var _auth = FirebaseAuth.instance;

Stream<User?> get loginState  {
      return _auth.authStateChanges();
}
  var error = "";
  //register with email
  Future SignUpwithE (String email, String Pass,String name,String major,int age) async{
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password:Pass,
      );
      User? user = userCredential.user;
      if (user !=null){
          await DatabaseService(uid: user.uid).UpdateUserData(name, major, age);
      }
      return user ;
    }  catch (e) {
      error = e.toString();
      return null;
    }
  }

  //Sign in with email
  Future SignIn (String email, String Pass) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password:Pass,
      );
      User? user = userCredential.user;
      return user ;
    }  catch (e) {
      error = e.toString();
      return null ;
    }
  }
  // Sign out
  Future SignOut () async{
    try {
      return await _auth.signOut();
    }  catch (e) {
      error = e.toString();
      return null ;
    }
  }
}