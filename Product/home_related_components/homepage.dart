import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/admin_related_files/adminpage.dart';
import 'package:cshliaiii/home_related_components/partnerspage.dart';
import 'package:cshliaiii/home_related_components/recentlycreatedstudents.dart';
import 'package:cshliaiii/home_related_components/studentsearch.dart';
import 'package:cshliaiii/login_related_screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cshliaiii/models/TimeTracker.dart';
import '../models/student.dart';
import '../models/usermodel.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final fullNameCon = new TextEditingController();
  final frequencyCon = new TextEditingController();
  final timeCon = new TextEditingController();
  final levelCon = new TextEditingController();
  // frequency is gonna be either weekly or biweekly but this is up to the user, only one time
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('appusers')
        .doc(user!.uid)
        .get()
        .then((loggedInUser){
      this.loggedInUser = UserModel.fromMap(loggedInUser.data());
      setState(() {});
    });
    // checkAdmin();
  }
  // void checkAdmin() {
  //   if(loggedInUser.isAdmin == "true") {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminPage()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final signOutButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton (
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              logout(context);
            },
            child: Text("Sign out", textAlign: TextAlign.center)
        )
    );
    final makeStudentButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton (
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              createStudent();
              setState(() {});
            },
            child: Text("Create Student", textAlign: TextAlign.center)
        )
    );
    final nameField = TextFormField(
      keyboardType: TextInputType.text,
      controller: fullNameCon,
      autofocus: false,
      validator: (value) {
        if(value!.isEmpty) {
          return ("Enter Name");
        }
      },
      onSaved: (value) {
        fullNameCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Full Name",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final levelField = TextFormField(
      keyboardType: TextInputType.text,
      controller: levelCon,
      autofocus: false,
      validator: (value) {
        if(value!.isEmpty) {
          return ("Enter level");
        }
      },
      onSaved: (value) {
        levelCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Student Level",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final frequencyField = TextFormField(
      keyboardType: TextInputType.text,
      controller: frequencyCon,
      autofocus: false,
      validator: (value) {
        if(value!.isEmpty) {
          return ("Enter Frequency");
        }
      },
      onSaved: (value) {
        frequencyCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Class Frequency",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final timeField = TextFormField(
      keyboardType: TextInputType.text,
      controller: timeCon,
      autofocus: false,
      validator: (value) {
        if(value!.isEmpty) {
          return ("Enter Class Time");
        }
      },
      onSaved: (value) {
        timeCon.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "Class Time",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final bottomNavBar = Container (
      color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              IconButton(onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));  } , icon: Icon(Icons.plus_one), color: Colors.white,),
              SizedBox(width: 60),
              IconButton(onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StudentSearch())); } , icon: Icon(Icons.search), color: Colors.white),
              SizedBox(width: 60),
              IconButton(onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PartnersPage())); } , icon: Icon(Icons.people), color: Colors.white),
              SizedBox(width: 60),
              IconButton(onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecentlyCreatedStudents())); } , icon: Icon(Icons.school), color: Colors.white),
            ],
          )
    );
    return Scaffold(

      appBar: AppBar(
        title: Text('${loggedInUser.fullName}' ", Create Student"),
        centerTitle: true,
      ),
      body: Center (
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Text("New Student", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              nameField,
              SizedBox(height: 10),
              levelField,
              SizedBox(height: 10),
              frequencyField,
              SizedBox(height: 10),
              timeField,
              SizedBox(height: 10),
              makeStudentButton,
              SizedBox(height: 20),
              signOutButton,
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }

  void createStudent() async {
    Student student = Student();
    student.fullName = fullNameCon.text;
    student.frequency = frequencyCon.text;
    student.level = levelCon.text;
    student.time = timeCon.text;
    bool unique = true;
    List tempStudents = [];
    // checking for non-unique docIDs
    await FirebaseFirestore.instance
        .collection('students')
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        tempStudents.add(element);
      }
    });
    for (int i = 0; i < tempStudents.length; i ++) {
      if(tempStudents[i]['fullName'] == student.fullName) {
        unique = false;
      }
    }
    // posting data to firestore if unique
    if(unique) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore
          .collection('students')
          .doc(student.fullName)
          .set(student.toMap());
      fullNameCon.text = "";
      frequencyCon.text = "";
      timeCon.text = "";
      levelCon.text = "";
      createPartnersList();
      addToRecentStudents(student.fullName!);
    }
    // nothing will happen if not unique
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    timeTracker.setEndingDT(DateTime.now());
    displayText2 = "Last Logout: " + timeTracker.getEndingDT().toString();
    setState(() {});
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));

  }
}
