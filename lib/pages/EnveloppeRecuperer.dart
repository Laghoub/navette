import 'package:flutter/material.dart';
import 'package:navette_application/Service/Attente.dart';
import 'package:navette_application/Service/Enveloppe.dart';
import 'package:navette_application/Service/Hub.dart';
import 'package:navette_application/Service/Services.dart';
import 'package:navette_application/Service/User.dart';
import 'package:navette_application/UsefulWidgets/ListeEnveloppeFiltrer.dart';
import 'package:navette_application/UsefulWidgets/ListeHubFiltre.dart';
import 'package:navette_application/UsefulWidgets/ListeVideWid.dart';
import 'package:navette_application/UsefulWidgets/ShowStepState.dart';
import 'package:navette_application/UsefulWidgets/TitreListeFiltrer.dart';

import 'Home.dart';

class EnveloppeRecuperer extends StatefulWidget {
  @override
  _EnveloppeRecupererState createState() => _EnveloppeRecupererState();
}

class _EnveloppeRecupererState extends State<EnveloppeRecuperer> {
  Attente attente = Attente(milliseconds: 1500);
  int validationState = -1;
  String hubSelectione = "";
  String validationMessage = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Hub> listHubs = Services.getListHubs();

  String email;
  String mdp;
  User user;

  List<Enveloppe> enveloppesRecupererList = [];
  List<Enveloppe> filteredEnveloppesRecupererList;

  void initState() {
    super.initState();

    filteredEnveloppesRecupererList = enveloppesRecupererList;
  }

  @override
  void didChangeDependencies() {
    Map data = ModalRoute.of(context).settings.arguments;
    email = data['email'] as String;
    user = data['user'] as User;
    mdp = data['mdp'] as String;
    if (validationState == -1)
      Services.getEnveloppeARecuperer(email, mdp, user.id).then((value) {
        setState(() {
          if (value != null) {
            enveloppesRecupererList = value;
            filteredEnveloppesRecupererList = enveloppesRecupererList;
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
          brightness: Brightness.light,
          backgroundColor: Colors.purple[900],
          title: Text("Récuperer les enveloppes"),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.filter_list, size: 30),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        /*Une barre qui s'affiche  aprés une clique sur le bouton de filtre pour exécuter des filtres*/
        endDrawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                SizedBox(height: 5),
                TitreListeFiltrer(titre: 'Filtrer par hub de départ'),
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
                          filteredEnveloppesRecupererList =
                              enveloppesRecupererList;
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
                          filteredEnveloppesRecupererList =
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
              child: ShowStepState(state: 2),
            ),
            Flexible(
              child: validationState == -1
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : enveloppesRecupererList.length == 0
                      ? ListeVideWidget(
                          text:
                              "Aucune enveloppe à recuperer dans votre liste\n")
                      : filteredEnveloppesRecupererList.length == 0
                          ? ListeVideWidget(
                              text:
                                  "Aucune enveloppe à recuperer pour ce filtre\n")
                          : ListeEnveloppeFiltrer(
                              liste: filteredEnveloppesRecupererList),
            ),
          ],
        ),
        floatingActionButton: MaterialButton(
          onPressed: () async {
            //var connected = await Services.isConnected();
            if (Home.connected) {
              _scaffoldKey.currentState.removeCurrentSnackBar();
              var nonSelectione = nbNonSelectionne();
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: AlertDialog(
                          title: Text("Confirmation"),
                          content: validationState == 0
                              ? Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text:
                                          'Vous confirmez la recupération de(s) '),
                                  TextSpan(
                                      text:
                                          '${filteredEnveloppesRecupererList.length - nonSelectione}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextSpan(text: ' enveloppe(s) !'),
                                ]))
                              : validationState == 1
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue))
                                  : validationState == 2
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  ShowStepState.valide,
                                              child: Stack(
                                                children: [
                                                  Icon(
                                                    Icons.money,
                                                    color: Colors.white,
                                                  ),
                                                  Positioned(
                                                      top: 2.0,
                                                      child: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors
                                                              .white,
                                                          size: 35))
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        "Enveloppes à recuperer\n",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                TextSpan(
                                                    text: "Etape Terminée",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.green,
                                                    ))
                                              ]),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  ShowStepState.nonValide,
                                              child: Stack(
                                                children: [
                                                  Icon(
                                                    Icons.money,
                                                    color: Colors.white,
                                                  ),
                                                  Positioned(
                                                      top: 2.0,
                                                      child: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors
                                                              .white,
                                                          size: 35))
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        "Enveloppe à récuperer\n",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                TextSpan(
                                                    text: "Etape Echouée\n",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red,
                                                    )),
                                                TextSpan(
                                                    text: "Motif : " +
                                                        validationMessage,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.grey[800],
                                                    ))
                                              ]),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                          actions: [
                            FlatButton(
                              child: Text("Annuler"),
                              onPressed: validationState == 0
                                  ? () {
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                            ),
                            FlatButton(
                              child: Text("Continuer"),
                              onPressed: validationState == 0
                                  ? () async {
                                      setState(() {
                                        validationState = 1;
                                      });
                                      if (filteredEnveloppesRecupererList
                                                  .length -
                                              nonSelectione !=
                                          0) {
                                        validationMessage =
                                            await Services.setStateEnveloppe(
                                                email,
                                                mdp,
                                                idEnveloppesRecuperer(),
                                                user.id);

                                        setState(() {
                                          print(validationMessage);
                                          if (validationMessage
                                                  .compareTo("true") ==
                                              0)
                                            validationState = 2;
                                          else
                                            validationState = 3;
                                        });
                                        attente.run(() {
                                          Navigator.of(context).pop();
                                          if (validationMessage
                                                  .compareTo("true") ==
                                              0)
                                            Navigator.pushReplacementNamed(
                                                context,
                                                '/home/packageRemettre',
                                                arguments: {
                                                  'user': user,
                                                  'email': email,
                                                  'mdp': mdp
                                                });
                                          else
                                            setState(() {
                                              validationState = 0;
                                            });
                                        });
                                      } else {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                            context, '/home/packageRemettre',
                                            arguments: {
                                              'user': user,
                                              'email': email,
                                              'mdp': mdp
                                            });
                                      }
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              });
            } else {
              _scaffoldKey.currentState.removeCurrentSnackBar();
              Services.showNoConnectionSnackBar(_scaffoldKey);
            }
          },
          child: Text(
            "Confirmer",
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
    return enveloppesRecupererList
        .where((u) => (hubSelectione.contains('*${u.hubArrive}-')))
        .toList();
  }

  int nbNonSelectionne() {
    return filteredEnveloppesRecupererList
        .where((element) => element.selected == false)
        .toList()
        .length;
  }

  String idEnveloppesRecuperer() {
    String enveloppesSelectione = '';
    filteredEnveloppesRecupererList.forEach((element) {
      if (element.selected)
        enveloppesSelectione = enveloppesSelectione + "${element.id},";
    });
    return enveloppesSelectione.substring(0, enveloppesSelectione.length - 1);
  }
}
