import 'package:flutter/material.dart';

import 'package:navette_application/Service/Attente.dart';
import 'package:navette_application/Service/Hub.dart';
import 'package:navette_application/Service/Enveloppe.dart';
import 'package:navette_application/Service/Manager.dart';
import 'package:navette_application/Service/Services.dart';
import 'package:navette_application/Service/User.dart';

import 'package:navette_application/UsefulWidgets/ShowStepState.dart';
import 'package:navette_application/UsefulWidgets/ListeEnveloppeFiltrer.dart';
import 'package:navette_application/UsefulWidgets/ListeVideWid.dart';
import 'package:navette_application/UsefulWidgets/ListeHubFiltre.dart';
import 'package:navette_application/UsefulWidgets/TitreListeFiltrer.dart';
import 'package:navette_application/UsefulWidgets/ListeReceveur.dart';
import 'package:navette_application/UsefulWidgets/SmsCodeConfiramtionWid.dart';

import 'Home.dart';

class EnveloppeRemettre extends StatefulWidget {
  @override
  _EnveloppeRemettreState createState() => _EnveloppeRemettreState();
}

class _EnveloppeRemettreState extends State<EnveloppeRemettre> {
  Attente attente = Attente(milliseconds: 3000);
  int validationState = -1;
  /* 
  -1=> loading liste
  0 => pas encore valider 
  1 => passage vers la confiramtion par code SMS
  2 => Envoie des données vers ER 
  3 => Opération terminée*/

  int typeCodeConfirmation;
  /*
  0=> code SMS 
  1=> code Email */
  String hubSelectione = "";

  String email;
  String mdp;
  User user;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //final List<Hub> listHubs = Services.getListHubs();

  Manager receveur;
  List<Manager> listReceveurs = [];
  List<Enveloppe> enveloppesRemetreList = [];
  List<Enveloppe> filteredEnveloppesRemetreList;
  List<Hub> listHubs = [];

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Map data = ModalRoute.of(context).settings.arguments;
    email = data['email'] as String;
    user = data['user'] as User;
    mdp = data['mdp'] as String;
    Services.getListHubs(email, mdp).then((value){
      setState(() {
        if (value != null) {
          listHubs = value;
        }
      });
    });
    if (validationState == -1)
      Services.getEnveloppeARemettre(email, mdp, user.id).then((value) {
        setState(() {
          if (value != null) {
            enveloppesRemetreList = value;
            filteredEnveloppesRemetreList = enveloppesRemetreList;
            validationState = 0;
          } else
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: AlertDialog(
                      title: Text("Panne"),
                      content: Text(
                          "Une panne est survenue au niveau du serveur, Veuillez réessayer plus tard"),
                      actions: [
                        FlatButton(
                            child: Text("Revenir à la page d'accueil"),
                            onPressed: () {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/home'));
                            }),
                      ],
                    ),
                  );
                });
              },
            );
        });
      });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[900],
      child: Scaffold(
        key: _scaffoldKey,
        /*Barre de Top contient un titre et bouton de filtrage */
        appBar: AppBar(
          automaticallyImplyLeading: validationState == 0 ? true : false,
          brightness: Brightness.dark,
          backgroundColor: Colors.purple[900],
          title: Text("Remettre les Enveloppes"),
          centerTitle: true,
          actions: [
            Builder(
                builder: (context) => validationState == 0
                    ? IconButton(
                        icon: Icon(Icons.filter_list, size: 30),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      )
                    : TextButton(
                        child: Text("Retour",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            if (validationState > 0) validationState--;
                          });
                        },
                      )),
          ],
        ),
        /*Une barre qui s'affiche  aprés une clique sur le bouton de filtre pour exécuter des filtres*/
        endDrawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                SizedBox(height: 5),
                TitreListeFiltrer(titre: 'Filtrer par hub d\'arrivée'),
                SizedBox(
                  height: 20,
                ),
                ListeHubFiltre(
                  listHubs: listHubs,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          listHubs.forEach((element) {
                            element.selected = true;
                          });
                          filteredEnveloppesRemetreList = enveloppesRemetreList;
                        });
                      },
                      height: 40,
                      child: Text(
                        'Réinitialiser',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      color: Colors.purple[900].withOpacity(0.95),
                      textColor: Colors.white,
                    ),
                    MaterialButton(
                      onPressed: () {
                        hubSelectione = '';
                        listHubs.forEach((element) {
                          if (element.selected)
                            hubSelectione = hubSelectione + "*${element.id}-";
                        });
                        Navigator.of(context).pop();
                        setState(() {
                          filteredEnveloppesRemetreList =
                              filtrage(hubSelectione);
                        });
                      },
                      height: 40,
                      child: Text(
                        'Appliquer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      color: Colors.purple[900].withOpacity(0.95),
                      textColor: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        /*le corps du screen : la liste des packages*/

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ShowStepState(state: 1),
            ),
            Flexible(
              child: validationState == -1
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : enveloppesRemetreList.length == 0
                      ? ListeVideWidget(
                          text:
                              "Aucune enveloppe à remettre dans votre liste\n")
                      : filteredEnveloppesRemetreList.length == 0
                          ? ListeVideWidget(
                              text:
                                  "Aucune enveloppe à remettre pour ce filtre\n")
                          : validationState == 0
                              ? ListeEnveloppeFiltrer(
                                  liste: filteredEnveloppesRemetreList)
                              : Column(
                                  children: [
                                    SmsCodeConfirmationWid(),
                                    validationState == 2
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: LinearProgressIndicator(
                                                minHeight: 2,
                                                semanticsLabel: "Patientez",
                                                //strokeWidth: 2.0,
                                                backgroundColor: Colors
                                                    .purple[900]
                                                    .withOpacity(0.9),
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.blue)),
                                          )
                                        : SizedBox(
                                            height: 5,
                                          ),
                                    SizedBox(height: 5),
                                    validationState == 2
                                        ? Center(
                                            child: Text(
                                            "Patientez, Svp!",
                                            style: TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ))
                                        : SizedBox(height: 5),
                                    SizedBox(height: 10),
                                    Text("Le code n'a pas été reçu?",
                                        style: TextStyle(
                                          color: Colors.red[700],
                                        )),
                                    SizedBox(height: 0),
                                    TextButton(
                                        onPressed: () async {
                                          //Ici on utilisant le type de code on renvoi le code vers le receveur
                                          bool sended = await Services
                                              .envoiCodeCofirmation(
                                                  moyen:
                                                      typeCodeConfirmation == 0
                                                          ? "sms"
                                                          : "email",
                                                  email: email,
                                                  mdp: mdp,
                                                  tel: receveur.telephone,
                                                  emailreceveur: receveur.mail,
                                                  ids: "${idEnveloppesRemi()}");
                                          if (sended == null) {
                                            showPanneServerDialog(context);
                                          }
                                        },
                                        child: Text("Envoyer un nouveau code",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.purple[900]
                                                  .withOpacity(0.95),
                                            )))
                                  ],
                                ),
            ),
          ],
        ),
        floatingActionButton: MaterialButton(
          onPressed: validationState == -1? null :
           enveloppesRemetreList.length != 0
              ? validationState == 2 //encours de la validation (teste de code)
                  ? null
                  : //Saisi du code de verification
                  () async {
                      //var connected = await Services.isConnected();
                      if (Home.connected) {
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        var nonSelectione = nbNonSelectionne();
                        if (validationState == 1) {
                          SmsCodeConfirmationWid.nonValidated = false;
                          if (SmsCodeConfirmationWid.keyform.currentState
                              .validate()) {
                            setState(() {
                              validationState++;
                            });
                            bool confirmed = await Services.confirmeCode(
                              email: email,
                              mdp: mdp,
                              codeconfirmation:
                                  SmsCodeConfirmationWid.smsCodeController.text,
                              ids: "${idEnveloppesRemi()}",
                            );
                            if (confirmed == null) {
                              showPanneServerDialog(context);
                              SmsCodeConfirmationWid.nonValidated = false;
                              setState(() {
                                validationState--;
                              });
                            } else {
                              SmsCodeConfirmationWid.nonValidated = !confirmed;
                              setState(() {
                                if (!SmsCodeConfirmationWid.keyform.currentState
                                    .validate())
                                  validationState--;
                                else {
                                  validationState--;
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return WillPopScope(
                                              onWillPop: () =>
                                                  Future.value(false),
                                              child: AlertDialog(
                                                title: Text("Terminaison"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          ShowStepState.valide,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.asset(
                                                            "assets/Caisse - Remise.png",
                                                            semanticLabel:
                                                                "Caisse Remise",
                                                          )), /*Stack(
                                                    children: [
                                                      Icon(
                                                        Icons.money,
                                                        color: Colors.white,
                                                      ),
                                                      Positioned(
                                                          bottom: 2.0,
                                                          child: Icon(
                                                            Icons.arrow_drop_up,
                                                            color: Colors
                                                                .white,
                                                            size: 35,
                                                          ))
                                                    ],
                                                  ),*/
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text.rich(
                                                      TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "Enveloppe à remettre\n",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )),
                                                        TextSpan(
                                                            text:
                                                                "Etape Terminée",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.green,
                                                            ))
                                                      ]),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    child: Text("Continuer"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              '/home/enveloppeRecuperer',
                                                              arguments: {
                                                            'user': user,
                                                            'email': email,
                                                            'mdp': mdp
                                                          });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        });
                                      });
                                }
                              });
                            }
                          }
                        } else {
                          if (validationState == 0) {
                            //Confirmation de la selection des enveloppes
                            receveur = managerSelectione();
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return WillPopScope(
                                    onWillPop: () => Future.value(false),
                                    child: AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text:
                                                'Vous confirmez la remise de(s) '),
                                        TextSpan(
                                            text:
                                                '${filteredEnveloppesRemetreList.length - nonSelectione}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(text: ' enveloppe(s) !\n'),
                                        TextSpan(
                                            text: receveur == null
                                                ? ''
                                                : 'Le receveur : '),
                                        TextSpan(
                                            text: receveur == null
                                                ? ''
                                                : '${receveur.nom}' +
                                                    " " +
                                                    "${receveur.prenom}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ])),
                                      actions: [
                                        FlatButton(
                                          child: Text("Annuler"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                            child: Text("SMS"),
                                            onPressed:
                                                filteredEnveloppesRemetreList
                                                                .length -
                                                            nonSelectione ==
                                                        0
                                                    ? null
                                                    : () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        validationState++;
                                                        typeCodeConfirmation =
                                                            0;
                                                          
                                                        Services.envoiCodeCofirmation(
                                                            moyen: "sms",
                                                            email: email,
                                                            mdp: mdp,
                                                            tel: receveur
                                                                .telephone,
                                                            emailreceveur:
                                                                receveur.mail,
                                                            ids:
                                                                "${idEnveloppesRemi()}");
                                                      }),
                                        FlatButton(
                                            child: Text("Email"),
                                            onPressed:
                                                filteredEnveloppesRemetreList
                                                                .length -
                                                            nonSelectione ==
                                                        0
                                                    ? null
                                                    : () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        validationState++;
                                                        typeCodeConfirmation =
                                                            1;
                                                        Services.envoiCodeCofirmation(
                                                            moyen: "email",
                                                            email: email,
                                                            mdp: mdp,
                                                            tel: receveur
                                                                .telephone,
                                                            emailreceveur:
                                                                receveur.mail,
                                                            ids:
                                                                "${idEnveloppesRemi()}");
                                                      }),
                                        FlatButton(
                                            child: Text("Continuer"),
                                            onPressed:
                                                filteredEnveloppesRemetreList
                                                                .length -
                                                            nonSelectione !=
                                                        0
                                                    ? null
                                                    : () {
                                                        Navigator.of(context)
                                                            .pop();

                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                '/home/enveloppeRecuperer',
                                                                arguments: {
                                                              'user': user,
                                                              'email': email,
                                                              'mdp': mdp
                                                            });
                                                      }),
                                      ],
                                    ),
                                  );
                                });
                              },
                            );
                          } else {
                            //POUR cnfirmer le choix de receveur et choix de la methode d'envoie SMS/Email
                            /*await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return WillPopScope(
                                onWillPop: () => Future.value(false),
                                child: AlertDialog(
                                  title: Text("Confirmation"),
                                  content: Text.rich(TextSpan(children: [
                                    TextSpan(text: 'Vous choisissez Ms/Mme '),
                                    TextSpan(
                                        text: listReceveurs[
                                                    ListeReceveur.selectedIndex]
                                                .nom
                                                .toUpperCase() +
                                            ' ' +
                                            listReceveurs[
                                                    ListeReceveur.selectedIndex]
                                                .prenom
                                                .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextSpan(
                                        text:
                                            ' pour confirmation de dépot des enveloppes'),
                                  ])),
                                  actions: [
                                    FlatButton(
                                      child: Text("Annuler"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                        child: Text("SMS"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          validationState++;
                                          typeCodeConfirmation = 0;
                                          Services.envoiCodeCofirmation(
                                              moyen: "sms",
                                              email: email,
                                              mdp: mdp,
                                              tel:
                                                  managerSelectione().telephone,
                                              emailreceveur:
                                                  managerSelectione().mail,
                                              ids: "${idEnveloppesRemi()}");
                                        }),
                                    FlatButton(
                                        child: Text("Email"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          validationState++;
                                          typeCodeConfirmation = 1;
                                          Services.envoiCodeCofirmation(
                                              moyen: "email",
                                              email: email,
                                              mdp: mdp,
                                              tel:
                                                  managerSelectione().telephone,
                                              emailreceveur:
                                                  managerSelectione().mail,
                                              ids: "${idEnveloppesRemi()}");
                                        }),
                                  ],
                                ),
                              );
                            });
                          },
                        );*/
                          }
                        }
                        setState(() {});
                      } else {
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        Services.showNoConnectionSnackBar(_scaffoldKey);
                      }
                    }
              : () {
                  Navigator.pushReplacementNamed(
                      context, '/home/enveloppeRecuperer',
                      arguments: {'user': user, 'email': email, 'mdp': mdp});
                },
          child: Text(
            enveloppesRemetreList.length != 0 ? "Confirmer" : "Continuer",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          color: Colors.purple[900].withOpacity(0.95),
          textColor: Colors.white,
          height: 40,
          minWidth: 150,
        ),
      ),
    );
  }

  List<Enveloppe> filtrage(String hubSelectione) {
    print(enveloppesRemetreList);
    print(hubSelectione);
    return enveloppesRemetreList.where((u) {
      print('*${u.hubArrive}-');
      return (hubSelectione.contains('*${u.hubArrive}-'));
    }).toList();
  }

  int nbNonSelectionne() {
    return filteredEnveloppesRemetreList
        .where((element) => element.selected == false)
        .toList()
        .length;
  }

  String idEnveloppesRemi() {
    String enveloppesSelectione = '';
    filteredEnveloppesRemetreList.forEach((element) {
      if (element.selected)
        enveloppesSelectione = enveloppesSelectione + "${element.id},";
    });
    return enveloppesSelectione.substring(0, enveloppesSelectione.length - 1);
  }

  Manager managerSelectione() {
    Enveloppe env = filteredEnveloppesRemetreList
        .firstWhere((element) => element.selected == true, orElse: () {
      return null;
    });
    print(env);
    if (env == null)
      return null;
    else
      return Manager(
          nom: env.nomRecepteur,
          prenom: env.prenomRecepteur,
          telephone: env.telRecepteur,
          mail: env.mailRecepteur);
  }
}

void showPanneServerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text("Panne"),
      content: Text(
          "Une panne est survenue au niveau de serveur, réessayer plus tard"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text("D'accord"),
        ),
      ],
    ),
  );
}
