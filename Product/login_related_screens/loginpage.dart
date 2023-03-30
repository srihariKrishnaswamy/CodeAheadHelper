import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/home_related_components/homepage.dart';
import 'package:cshliaiii/home_related_components/partnerspage.dart';
import 'package:cshliaiii/models/TimeTracker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../admin_related_files/adminpage.dart';
import '../models/usermodel.dart';
import 'newacctpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

List regUsers = [];
TimeTracker timeTracker = new TimeTracker();
String? displayText1 = "";
String? displayText2 = "";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();

  TextEditingController emailCon = new TextEditingController();
  TextEditingController pwCon = new TextEditingController();


  //firebase things
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final emailFormField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailCon,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
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
          border: OutlineInputBorder()
      ),
    );
    final pwFormField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: pwCon,
      autofocus: false,
      validator: (value) {
        RegExp exp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Enter Password");
        }
        if (!exp.hasMatch(value)) {
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
          border: OutlineInputBorder()
      ),
    );

    final signInButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery
                .of(context)
                .size
                .width,
            onPressed: () {
              signIn(emailCon.text, pwCon.text);
            },
            child: Text("Sign in", textAlign: TextAlign.center)
        )
    );
    final signupButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery
                .of(context)
                .size
                .width,
            onPressed: () {
              getRegUsersList();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewAcctPage()));
            },
            child: Text("Sign Up", textAlign: TextAlign.center)
        )
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(displayText1!),
                            SizedBox(height: 10),
                            Text(displayText2!),
                            SizedBox(height: 10),
                            Text("CodeAhead Scheduler Sign-In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),),
                            SizedBox(
                              height: 50,
                            ),
                            emailFormField,
                            SizedBox(
                              height: 20,
                            ),
                            pwFormField,
                            SizedBox(
                              height: 50,
                            ),
                            signInButton,
                            SizedBox(
                              height: 15,
                            ),
                            signupButton
                          ],
                        )
                    ),
                  )
              ),
            )
        )
    );
  }

  void signIn(String email, String password) async {
    if (_key.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) =>
      {
        Fluttertoast.showToast(msg: "Successful Login"),
        timeTracker.setStartingDT(DateTime.now()),
        displayText1 = "Last Login: " + timeTracker.getStartingDT().toString(),
        setState(() {}),
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()))
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      regUsers = [];
      checkIfAdmin(emailCon.text);
      createPartnersList();
    }
  }

  void checkIfAdmin(String email) async {
    List users = [];
    getRegUsersList();
    await FirebaseFirestore.instance.collection('appusers').get().then((
        querySnapshot) {
      for (var element in querySnapshot.docs) {
        users.add(element);
      }
    });
    for (int i = 0; i < users.length; i++) {
      if(users[i]['email'] == email) {
        if (users[i]['isAdmin'] == 'true') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminPage()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    }
  }
}

Future<String> getRegUsersList() async {
  regUsers = [];
  List users = [];
  await FirebaseFirestore.instance
      .collection('appusers')
      .get()
      .then((querySnapshot) {
    for (var element in querySnapshot.docs) {
      users.add(element);
    }
  });
  for (int i = 0; i < users.length; i++) {
    if (users[i]['isAdmin'] == 'false') {
      regUsers.add(users[i]);
    }
  }
  return "placeholder";
}
