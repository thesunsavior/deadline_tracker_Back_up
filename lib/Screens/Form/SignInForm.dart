import 'package:deadline_tracker/Screens/Register.dart';
import 'package:deadline_tracker/Screens/Form/RegisterForm.dart';
import 'package:deadline_tracker/Service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}
var crrEmail = "";
var crrPassword ="";
var _auth = AuthService();

var formkey = GlobalKey<FormState>();
class _SignInFormState extends State<SignInForm> {
  var error ="";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade900),
        borderRadius: BorderRadius.all(Radius.circular(18))
      ),
      padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Form(
        key: formkey,
        child: Column(
          children: [
            Text("Sign In",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ), ),
            SizedBox(height: 20,),
            TextFormField(
              validator: (val) => val!.isEmpty? "must enter email":null,
              onChanged: (val){
                setState(() {
                  crrEmail = val;
                });
              },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,color: Colors.black,),
                  labelText: "Email",
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
            TextFormField(
              validator: (val) => val!.length<6? "this is shorter than your penis, more than 6 plz":null,
              onChanged: (val){
                setState(() {
                  crrPassword = val;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_open,color: Colors.black,),
                  labelText: "Password",
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () async {
                  if (formkey.currentState!.validate()){
                    var user = await _auth.SignIn(crrEmail, crrPassword);
                    if (user == null){
                      setState(() {
                        error = _auth.error;
                      });
                      print ("gay~");
                    }
                  }
                  print(crrEmail);
                  print (crrPassword);
                },
                  child: Text("Login"),
                  style:  ElevatedButton.styleFrom(
                      primary: Colors.black
                  ),),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context,  MaterialPageRoute(builder: (context) => SignUp()),);
                },
                  child: Text("Register"),
                  style:  ElevatedButton.styleFrom(
                      primary: Colors.grey.shade700
                  ),),

              ],
            ),
            SizedBox(height:10),
            Text(error,style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ))
          ],
        ),
      ),
    );
  }
}
