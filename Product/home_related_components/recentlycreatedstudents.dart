import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/admin_related_files/adminpage.dart';
import 'package:cshliaiii/home_related_components/editstudent.dart';
import 'package:cshliaiii/home_related_components/partnerspage.dart';
import 'package:cshliaiii/home_related_components/studentsearch.dart';
import 'package:cshliaiii/login_related_screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/usermodel.dart';
import 'homepage.dart';
class RecentlyCreatedStudents extends StatefulWidget {
  const RecentlyCreatedStudents({Key? key}) : super(key: key);

  @override
  _RecentlyCreatedStudentsState createState() => _RecentlyCreatedStudentsState();
}

class _RecentlyCreatedStudentsState extends State<RecentlyCreatedStudents> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Recently Added Students"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: allRecentStudents.size(),
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(allRecentStudents.toList()[index].fullName),
                leading: Icon(Icons.school),
                tileColor: Colors.grey,
                onTap: () async {
                  delFromRecentStudents(allRecentStudents.toList()[index].fullName);
                  createPartnersList();
                },
              ),
            );
          }),
      bottomNavigationBar: bottomNavBar,
    );
  }
  void delFromRecentStudents(String fullName) async {
    allRecentStudents.deleteElement(fullName);
    await FirebaseFirestore.instance
        .collection('students').doc(fullName).delete();
    setState(() {});
  }
}
void addToRecentStudents(String fullName) {
  allRecentStudents.add(fullName);
}