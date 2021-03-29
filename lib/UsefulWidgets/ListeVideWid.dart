import 'package:flutter/material.dart';

class ListeVideWidget extends StatelessWidget {

  final String text ;
  
  ListeVideWidget({this.text}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Center(
                        child: Text(
                          text ,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.purple[900].withOpacity(0.90),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ));
  }
}