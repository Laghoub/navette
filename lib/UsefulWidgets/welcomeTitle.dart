import 'package:flutter/material.dart';

class WelcomeTitle extends StatelessWidget {

    final String text;

const WelcomeTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
       "$text, bienvenue dans l'espace Easy-Relay",
      style: TextStyle(fontSize: 25, color: Colors.purple[900].withOpacity(0.7), fontWeight: FontWeight.bold),
    );
   
  }
}