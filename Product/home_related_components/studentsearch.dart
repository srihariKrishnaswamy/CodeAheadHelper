import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/admin_related_files/adminpage.dart';
import 'package:cshliaiii/home_related_components/editstudent.dart';
import 'package:cshliaiii/home_related_components/partnerspage.dart';
import 'package:cshliaiii/home_related_components/recentlycreatedstudents.dart';
import 'package:cshliaiii/login_related_screens/loginpage.dart';
import 'package:cshliaiii/models/RecentStudentNodeList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/usermodel.dart';
import 'homepage.dart';

RecentStudentNodeList allRecentStudents = RecentStudentNodeList();

Student currentStudent = Student();

class StudentSearch extends StatefulWidget {
  const StudentSearch({Key? key}) : super(key: key);

  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {

  final fullNameCon = new TextEditingController();
   // will be used for deletion and displaying

  @override
  Widget build(BuildContext context) {
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
          hintText: "Student Full Name",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final searchButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton (
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              searchStudents(fullNameCon.text);
              fullNameCon.text = "";
            },
            child: Text("Search", textAlign: TextAlign.center)
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Student"),
        centerTitle: true,
      ),
      body: Center (
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Text("Search Student", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              nameField,
              SizedBox(height: 20),
              searchButton
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }

  void searchStudents(String targetName) async {
    currentStudent = Student();
    List students = [];
    await FirebaseFirestore.instance.collection('students').get().then((
        querySnapshot) {
      for (var element in querySnapshot.docs) {
        students.add(element);
      }
    });
    for (int i = 0; i < students.length; i ++) {
      if(targetName == students[i]['fullName']) {
        currentStudent = Student.fromMap(students[i].data());
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditStudent()));
      }
    }
  }



}