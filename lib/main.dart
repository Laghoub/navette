import 'package:flutter/material.dart';
import 'package:navette_application/pages/EnvTest.dart';
//import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:navette_application/pages/Home.dart';
import 'package:navette_application/pages/PackageRecuperer.dart';
import 'package:navette_application/pages/PackageRemettre.dart';
import 'package:navette_application/pages/login.dart';
import 'package:navette_application/pages/EnveloppeRemettre.dart';
import 'package:navette_application/pages/EnveloppeRecuperer.dart';


void main() {
  kNotificationSlideDuration = const Duration(milliseconds: 500);
  kNotificationDuration = const Duration(milliseconds: 1500);
  return runApp(OverlaySupport(
      child: MaterialApp(
      initialRoute: '/test',
      routes: {
        '/test': (context) => EnvTest(),
        '/': (context) => Login(),
        '/home' : (context) => Home(),
        '/home/packageRemettre' : (context) => PackageRemettre(),
        '/home/packageRecuperer' : (context) => PackageRecuperer(),
        '/home/enveloppeRemettre' : (context) => EnveloppeRemettre(),
        '/home/enveloppeRecuperer' : (context) => EnveloppeRecuperer(),
      }
),
  ));}