import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class TimeTracker {
  DateTime _startingDT = DateTime.now();
  DateTime _endingDT = DateTime.now();
  void setStartingDT(DateTime dt) {
    _startingDT = dt;
  }
  DateTime getStartingDT() {
    return _startingDT;
  }
  void setEndingDT(DateTime dt) {
    _endingDT = dt;
  }
  DateTime getEndingDT() {
    return _endingDT;
  }
}