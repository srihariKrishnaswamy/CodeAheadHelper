import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserModel {
  String? userID;
  String? email;
  String? fullName;
  String? isAdmin;
  UserModel ({this.userID, this.email, this.fullName, this.isAdmin}) ;
factory UserModel.fromMap(map) {
  return UserModel(
    userID: map['userID'],
    email: map['email'],
    fullName: map['fullName'],
    isAdmin: map['isAdmin']
  );
}
Map<String, dynamic> toMap() {
  return {
    'userID': userID,
    'email': email,
    'fullName': fullName,
    'isAdmin': isAdmin
  };
}
}