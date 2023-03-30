import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Student {
  String? fullName;
  String? level;
  String? frequency;
  String? time;

  Student ({this.fullName, this.level, this.frequency, this.time}) ;

  // getting data from fb
  factory Student.fromMap(map) {
    return Student(
        fullName: map['fullName'],
        level: map['level'],
        frequency: map['frequency'],
      time: map['time'],
    );
  }

// sending data to fb
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'level': level,
      'frequency': frequency,
      'time': time,
    };
  }

}