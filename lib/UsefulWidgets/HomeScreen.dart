import 'package:flutter/material.dart';
import 'package:navette_application/Service/Services.dart';
import 'package:navette_application/Service/User.dart';
import 'package:navette_application/UsefulWidgets/welcomeTitle.dart';
import 'package:navette_application/pages/Home.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey ;
  final User user;
  final String email, mdp;

  const HomeScreen({this.user, this.email, this.mdp,this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: WelcomeTitle(
                    text: '${user.nom.toUpperCase()} ${user.prenom}')),
            SizedBox(
              height: 20,
            ),
            Text('Pour commencer votre mission, cliquer sur commencer...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                )),
            SizedBox(height: 80),
            Center(
              child: FlatButton(
                onPressed: () async {
                 // var connected = await Services.isConnected();
               if(Home.connected){
              Navigator.pushNamed(context, '/home/enveloppeRemettre',
                  arguments: {'user': user, 'email' : email, 'mdp': mdp});}
                  else{
                    Services.showNoConnectionSnackBar(scaffoldKey) ;
                  }
            },
              
                height: 40,
                minWidth: 150,
                child: Text(
                  'Commencer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                color: Colors.purple[900].withOpacity(0.95),
                textColor: Colors.white,
              ),
            )
          ],
        ));
  }
}
