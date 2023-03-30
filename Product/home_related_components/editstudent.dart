import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/admin_related_files/adminpage.dart';
import 'package:cshliaiii/home_related_components/partnerspage.dart';
import 'package:cshliaiii/login_related_screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/usermodel.dart';
import 'homepage.dart';
import 'studentsearch.dart';
class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {

  final frequencyCon = new TextEditingController();
  final timeCon = new TextEditingController();
  final levelCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final delStudentButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton (
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              delStudent(currentStudent.fullName!);
              setState(() {});
            },
            child: Text("Delete Student", textAlign: TextAlign.center)
        )
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
        if(value!.isEmpty) {
          levelCon.text = currentStudent.level!;
        } else {
          levelCon.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "${currentStudent.level}",
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
        if(value!.isEmpty) {
          frequencyCon.text = currentStudent.frequency!;
        } else {
          frequencyCon.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "${currentStudent.frequency}",
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
        if(value!.isEmpty) {
          timeCon.text = currentStudent.time!;
        } else {
          timeCon.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: "${currentStudent.time}",
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          border: OutlineInputBorder ()
      ),
    );
    final updateStudentButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
        child: MaterialButton (
            padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              updateStudent();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StudentSearch()));
              setState(() {});
            },
            child: Text("Update Student", textAlign: TextAlign.center)
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Properties"),
        centerTitle: true,
        leading: IconButton (
          icon : Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StudentSearch()));
          },
        ),
      ),
      body: Center (
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Text("Student: " + " ${currentStudent.fullName}", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              levelField,
              SizedBox(height: 10),
              frequencyField,
              SizedBox(height: 10),
              timeField,
              SizedBox(height: 20),
              updateStudentButton,
              SizedBox(height: 10),
              delStudentButton
            ],
          ),
        ),
      ),
    );
  }
  void delStudent(String fullName) async {

    await FirebaseFirestore.instance
        .collection('students').doc(fullName).delete();
    currentStudent = Student();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StudentSearch()));
    createPartnersList();
    allRecentStudents.deleteElement(fullName);
    // linkedlist stuff
  }

void updateStudent() async {
  Student student = Student();
  student.fullName = currentStudent.fullName;
  if(frequencyCon.text.isEmpty) {
    student.frequency = currentStudent.frequency;
  } else {
    student.frequency = frequencyCon.text;
  }
  if(levelCon.text.isEmpty) {
    student.level = currentStudent.level;
  } else {
    student.level = levelCon.text;
  }

  if(timeCon.text.isEmpty) {
    student.time = currentStudent.time;
  } else {
    student.time = timeCon.text;
  }
  currentStudent = Student(); // resetting currentStudent
  // posting data to firestore if unique
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('students').doc(student.fullName).update({
      'fullName': student.fullName, 'frequency': student.frequency, 'level': student.level, 'time': student.time
    });
    frequencyCon.text = "";
    timeCon.text = "";
    levelCon.text = "";
  createPartnersList();
}
}
