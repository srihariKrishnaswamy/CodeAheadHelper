import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cshliaiii/login_related_screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/usermodel.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                logout(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
              }
          ),
          title: Text('Admin View: Hold to Delete Teacher'),
          centerTitle: true,
        ),
        body: ListView.builder(
                itemCount: regUsers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(regUsers[index]['fullName'] + ", " + regUsers[index]['email']),
                      leading: Icon(Icons.person),
                      tileColor: Colors.grey,
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('appusers').doc(regUsers[index]['userID']).delete();
                        regUsers.remove(regUsers[index]);
                        setState(() { });
                      },
                    ),
                  );
                }),
        );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    timeTracker.setEndingDT(DateTime.now());
    displayText2 = "Last Logout: " + timeTracker.getEndingDT().toString();
    setState(() {});
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));

  }
}