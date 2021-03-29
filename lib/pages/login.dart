import 'package:flutter/material.dart';
import 'package:navette_application/Service/Services.dart';
import '../Animation/FadeAnimation.dart';
import '../Service/User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final mdpController = TextEditingController();
  FocusNode mdpFocus = new FocusNode();
  FocusNode emailFocus = new FocusNode();

  int _stateLogin = 0;
  bool connexionEchouee = false;

  @override
  void dispose() {
    emailController.dispose();
    mdpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[900],
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
              _stateLogin = 0;
            }
          },
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeAnimation(
                    1,
                    Container(
                      margin: EdgeInsets.only(top: 120, bottom: 40),
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      children: [
                        /*FadeAnimation(
                          1,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            child: Text(
                              "Bienvenue, \nChauffeur navette",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.purple[900].withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),*/
                        FadeAnimation(
                          1,
                          Container(
                            /*decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent,
                          ),*/
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 30),
                                    child: TextFormField(
                                      controller: emailController,
                                      focusNode: emailFocus,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Veuillez entrer votre adresse e-mail';
                                        }
                                        if (connexionEchouee) {
                                          return 'Email ou mot de passe erroné';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.purple[900],
                                          fontSize: 18.0,
                                          //fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Colors.purple[900]
                                                  .withOpacity(0.6)),
                                        ),
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 30),
                                    child: TextFormField(
                                      controller: mdpController,
                                      focusNode: mdpFocus,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Veuillez entrer votre mot de passe';
                                        }

                                        if (connexionEchouee) {
                                          return 'Email ou mot de passe erroné';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        color: Colors.purple[900],
                                        fontSize: 18.0,
                                        //fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.purple[900]
                                                    .withOpacity(0.6)),
                                          ),
                                          hintText: "Mot de Passe",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /*Center(
                        child: FadeAnimation(
                          1,
                          FlatButton(
                              onPressed: () {},
                              child: Text(
                                "Mot de passe oublier?",
                                style: TextStyle(
                                  color: Colors.pink[200],
                                ),
                              )),
                        ),
                      ),*/
                        SizedBox(
                          height: 40.0,
                        ),
                        FadeAnimation(
                          1,
                          Container(
                            child: Center(
                              child: MaterialButton(
                                  height: 45,
                                  minWidth: 180.0,
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  color: Colors.purple[800],
                                  child: setUpButtonChild(),
                                  /*Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),*/
                                  onPressed: _stateLogin == 1
                                      ? null
                                      : () async {
                                          mdpFocus.unfocus();
                                          emailFocus.unfocus();
                                          if (_formKey.currentState
                                              .validate()) {
                                            var email = emailController.text;
                                            var mdp = mdpController.text;
                                            setState(() {
                                              _stateLogin = 1;
                                            });
                                            var connected =
                                                await Services.isConnected();
                                            if (connected) {
                                              User user =
                                                  await Services.userLogin(
                                                      email, mdp);
                                              if ((user.id != '-1') &&
                                                  (user.id != '-2')) {
                                                //si l'utilisateur existe(-1) et aucune panne au niveau de serveur(-2)
                                                connexionEchouee = false;
                                                _stateLogin = 0;
                                                //print("hello" + user.nom);
                                                Navigator.pushReplacementNamed(
                                                    context, '/home',
                                                    arguments: {
                                                      'user': user,
                                                      'email': email,
                                                      'mdp': mdp
                                                    });
                                              } else {
                                                if ((user.id == '-1')) {
                                                  setState(() {
                                                    connexionEchouee = true;
                                                    _formKey.currentState
                                                        .validate();
                                                    _stateLogin = 0;
                                                    connexionEchouee = false;
                                                  });
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                      title: Text("Panne"),
                                                      content: Text(
                                                          "Une panne est survenue au niveau de serveur, réessayer plus tard"),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _stateLogin = 0;
                                                            });
                                                            Navigator.of(ctx)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text("D'accord"),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  _stateLogin = 0;
                                                }
                                              }
                                            }else {
                                            await showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text("Connexion"),
                                                content: Text(
                                                    "Veuillez vous verifier votre connexion internet"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _stateLogin = 0;
                                                      });
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text("D'accord"),
                                                  ),
                                                ],
                                              ),
                                            );
                                            _stateLogin = 0;
                                          }
                                          } 
                                          
                                        }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget setUpButtonChild() {
    if (_stateLogin == 0) {
      return Text(
        "Connexion",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else {
      return CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        //AnimationController().drive(ColorTween(begin: Colors.white,  end : Colors.blue)),
      );
    }
  }
}
