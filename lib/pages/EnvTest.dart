import 'package:flutter/material.dart';
import 'package:navette_application/Globals/globals.dart';
import 'package:navette_application/pages/login.dart';

class EnvTest extends StatefulWidget {
  const EnvTest({ Key key }) : super(key: key);

  @override
  State<EnvTest> createState() => _EnvTestState();
}

class _EnvTestState extends State<EnvTest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("Veuillez Choisir un environnement de test",
               
               style: TextStyle(
                 fontSize: 20,
               ),
               textAlign: TextAlign.center,
               ),

               SizedBox(
                 height:30
               ),

               RaisedButton(
                 color: const Color(0xff536DFE),
                 textColor: Colors.white,
                 child:Text("Développement"),
                 onPressed: (){
                   setState(() {
                     GlobalVarsSingleton().env = '51.91.56.9:2021';
                     GlobalVarsSingleton().mob = 'mob2';

                   });
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
                 },
               ),

               SizedBox(
                 height:30
               ),

               RaisedButton(
                 child:Text("Pré-production"),
                 color: const Color(0xffFFC107),
                 textColor: Colors.white,
                 onPressed: (){
                   setState(() {
                     GlobalVarsSingleton().env = 'pre-prod.easy-relay.com';
                     GlobalVarsSingleton().mob = 'mob_beta';

                   });
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
                 },
               ),

               SizedBox(
                 height:30
               ),

               RaisedButton(
                 color: const Color(0xff4CAF50),
                 textColor: Colors.white,
                 child:Text("Production"),
                 onPressed: (){
                   setState(() {
                     GlobalVarsSingleton().env = 'bo.easy-relay.com';
                     GlobalVarsSingleton().mob = 'mob2';
                   });
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
                 },
               ),

             ],
            ),
          ),
        ),
      )
    );
  }
}