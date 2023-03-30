import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/home_related_components/homepage.dart';
import 'package:cshliaiii/login_related_screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../admin_related_files/adminpage.dart';
import '../models/usermodel.dart';
class NewAcctPage extends StatefulWidget {
  const NewAcctPage({Key? key}) : super(key: key);

  @override
  _NewAcctPageState createState() => _NewAcctPageState();
}

class _NewAcctPageState extends State<NewAcctPage> {

  final realAdminKey = "admin";
  final _auth = FirebaseAuth.instance;

  final _key = GlobalKey<FormState>();
  final nameCon = new TextEditingController();
  final emailCon = new TextEditingController();
  final pwCon = new TextEditingController();
  final adminKeyCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final nameFormField = TextFormField(
      keyboardType: TextInputType.text,
      controller: nameCon,
      autofocus: false,
      validator: (value) {
        RegExp exp = RegExp(r'^.{3,}$');
        if(value!.isEmpty) {
          return ("Enter Name");
        }
        if(!exp.hasMatch(value)) {
          return ("Enter Longer Name");
        }
      },
      onSaved: (value) {
        nameCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Full Name",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );

    final emailFormField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailCon,
      autofocus: false,
      validator: (value) {
        if(value!.isEmpty) {
          return ("Enter Email");
        }
        // if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.{a-z}").hasMatch(value)) {
        //   return ("Enter valid email");
        // }
        return null;
      },
      onSaved: (value) {
        emailCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Email",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final pwFormField = TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      controller: pwCon,
      autofocus: false,
      validator: (value) {
        RegExp exp = RegExp(r'^.{6,}$');
        if(value!.isEmpty) {
          return ("Enter Password");
        }
        if(!exp.hasMatch(value)) {
          return ("Enter Longer Password");
        }
      },
      onSaved: (value) {
        pwCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Password",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final adminKeyFormField = TextFormField(
      keyboardType: TextInputType.text,
      controller: adminKeyCon,
      autofocus: false,
      // validator: () {
      //
      // },
      onSaved: (value) {
        adminKeyCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Enter Admin Key (If Admin)",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final makeAccountButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton (
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              signUp(emailCon.text, pwCon.text);
              getRegUsersList();
            },
            child: Text("Create Account", textAlign: TextAlign.center)
        )
    );

    return Scaffold(
      appBar: AppBar (
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton (
          icon : Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
              child: Container(
                  color: Colors.white,

                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form (
                        key: _key,
                        child: Column (
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
                            Text("CodeAhead Scheduler Account Creation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                            SizedBox(
                              height: 50,
                            ),
                            nameFormField,
                            SizedBox(
                              height: 20,
                            ),
                            emailFormField,
                            SizedBox(
                              height: 20,
                            ),
                            pwFormField,
                            SizedBox(
                              height: 15,
                            ),
                            adminKeyFormField,
                            SizedBox(
                              height: 15,
                            ),
                            makeAccountButton
                          ],
                        )
                    ),
                  )
              ),
            )
        )
    );
  }
  void signUp(String email, String pw) async {
    if(_key.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: pw)
          .then((value) => {
            postDetailsToFirestore(),
        timeTracker.setStartingDT(DateTime.now()),
        displayText1 = "Last Login: " + timeTracker.getStartingDT().toString(),
        setState(() {}),
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
  postDetailsToFirestore() async {
    getRegUsersList(); // to update the admin screen incase thats where were going
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.userID = user.uid;
    userModel.fullName = nameCon.text;
    bool routingToHome = true;
    if(adminKeyCon.text == realAdminKey) {
      userModel.isAdmin = "true";
      routingToHome = false;
    } else {
      userModel.isAdmin = "false";
    }
    await firebaseFirestore
    .collection('appusers')
    .doc(user.uid)
    .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Successfully Created");
    if(routingToHome) {
      Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => AdminPage()), (route) => false);
    }

  }
}
