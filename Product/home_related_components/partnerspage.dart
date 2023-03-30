import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/admin_related_files/adminpage.dart';
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
import 'homepage.dart';

List partnersList = [];
class PartnersPage extends StatefulWidget {
  const PartnersPage({Key? key}) : super(key: key);

  @override
  _PartnersPageState createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  @override
  void initState() {
    super.initState();
  }
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
            IconButton(onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PartnersPage())); } , icon: Icon(Icons.people), color: Colors.white),
            SizedBox(width: 60),
            IconButton(onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecentlyCreatedStudents())); } , icon: Icon(Icons.school), color: Colors.white),
          ],
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Partners"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: partnersList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(partnersList[index][0] + ", " + partnersList[index][1]),
                leading: Icon(Icons.people),
                tileColor: Colors.grey,
                onTap: () async {
                },
              ),
            );
          }),
      bottomNavigationBar: bottomNavBar,
    );
  }
}

void createPartnersList() async {
  List allKids = [];
  partnersList = [];
  List alreadyPartnered = [];
  await FirebaseFirestore.instance.collection('students').get().then((
      querySnapshot) {
    for (var element in querySnapshot.docs) {
      allKids.add(element);
    }
  }); // putting all students in allStudents
  Iterator<dynamic> itr = allKids.iterator;
  while(itr.moveNext()) {
    Iterator<dynamic> itr2 = allKids.iterator;
    while(itr2.moveNext()) {
      if(itr.current['time'] == itr2.current['time'] && itr.current['fullName'] != itr2.current['fullName']) {
        if(!alreadyPartnered.contains(itr.current['fullName']) && !alreadyPartnered.contains(itr2.current['fullName'])) {
          List temp = [];
          temp.add(itr.current['fullName']);
          temp.add(itr2.current['fullName']);
          partnersList.add(temp);
          alreadyPartnered.add(itr.current['fullName']);
          alreadyPartnered.add(itr2.current['fullName']);
        }
      }
    }
  }
}
