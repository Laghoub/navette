import 'dart:async';
import 'package:flutter/material.dart';

class Attente {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Attente({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}