import 'package:flutter/material.dart';
import 'package:navette_application/Service/User.dart';
import 'package:navette_application/UsefulWidgets/ProfilItem.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final String email, mdp;
  static bool isMdpObscure = true ;

  const ProfileScreen({this.user, this.email, this.mdp});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListView(
              children:[ Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: CircleAvatar(
                backgroundColor: Colors.lightBlue[200].withOpacity(0.9),
                child: Text(widget.user.nom.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.purple[900],
                      fontSize: 60,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100].withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Text(ProfileScreen.isMdpObscure?/*r'[0-9a-zA-Z]'*/
                        'Email : ${widget.email}\n\nMot de Passe : ${widget.mdp.replaceAll(new RegExp(".?"), "-")}': 'Email : ${widget.email}\n\nMot de Passe : ${widget.mdp}',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 17.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed : (){setState((){
                          ProfileScreen.isMdpObscure = !ProfileScreen.isMdpObscure ;
                        });} ,
                        child : Row
                        (mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(ProfileScreen.isMdpObscure? "Afficher le mot de passe  ":"Masquer le mot de passe  "),
                          Icon(ProfileScreen.isMdpObscure? Icons.visibility_outlined:Icons.visibility_off_outlined, color : Colors.blue)
                        ],)
                      )
                    ],
                  ),
                )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100].withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        ProfilItem(
                          titre: 'Identifiant ',
                          detail: widget.user.id,
                        ),
                        ProfilItem(
                          titre: 'Nom',
                          detail: widget.user.nom,
                        ),
                        ProfilItem(
                          titre: 'Prenom',
                          detail: widget.user.prenom,
                        ),
                        ProfilItem(
                          titre: 'N° télephone',
                          detail: widget.user.telephone,
                        )
                      ],
                    ))),
                    SizedBox(height :  20),
            Center(
                child: MaterialButton(
              height: 45,
              minWidth: 180.0,
              padding: EdgeInsets.symmetric(horizontal: 50),
              color: Colors.purple[800],
              child: Text(
                "Déconnexion",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {Navigator.pushReplacementNamed(context, '/',);},
            )),
          ],
        ),]
      ),
    );
  }
}
