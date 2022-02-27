import 'package:deadline_tracker/Service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}
var crrEmail = "";
var crrPassword ="";
var name = "";
var age  = 0 ;
var major= "";
var _auth = AuthService();
var formkey = GlobalKey<FormState>();

class _RegisterFormState extends State<RegisterForm> {
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
            Text("Sign Up",style: TextStyle(
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
            TextFormField(
              validator: (val) => val!.isEmpty? "this is required":null,
              onChanged: (val){
                setState(() {
                  name = val;
                });
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.black,),
                  labelText: "Name",
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
            TextFormField(
              validator: (val) => val!.isEmpty? "this is required":null,
              keyboardType: TextInputType.number,
              onChanged: (val){
                setState(() {
                  age = int.parse(val);
                });
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.access_time,color: Colors.black,),
                  labelText: "Age",
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
            TextFormField(
              validator: (val) => val!.isEmpty? "this is required":null,
              onChanged: (val){
                setState(() {
                  major = val;
                });
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.grade,color: Colors.yellow.shade600,),
                  labelText: "Major",
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
            ElevatedButton(onPressed: () async {
              if(formkey.currentState!.validate()){
                  dynamic user = await _auth.SignUpwithE(crrEmail, crrPassword,name,major,age);
                  if (user == null)
                    {
                      setState(() {
                        error =  _auth.error;
                      });
                      print (user);
                    }
                 else Navigator.pop(context);

              }
            },
              child: Text("Sign up"),
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
    );
  }
}
