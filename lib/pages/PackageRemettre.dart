import 'package:flutter/material.dart';
import 'package:navette_application/Service/Attente.dart';
import 'package:navette_application/Service/Hub.dart';
import 'package:navette_application/Service/Package.dart';
import 'package:navette_application/Service/Services.dart';
import 'package:navette_application/Service/User.dart';
import 'package:navette_application/UsefulWidgets/ListeHubFiltre.dart';
import 'package:navette_application/UsefulWidgets/ListeVideWid.dart';
import 'package:navette_application/UsefulWidgets/ShowStepState.dart';
import 'package:navette_application/UsefulWidgets/TitreListeFiltrer.dart';

import 'Home.dart';

class PackageRemettre extends StatefulWidget {
  @override
  _PackageRemettreState createState() => _PackageRemettreState();
}

class _PackageRemettreState extends State<PackageRemettre> {
  Attente attente = Attente(milliseconds: 1500);
  int validationState = -1;
  String validationMessage = "";
/*
-1 => chargement de la liste
0 => Selection
1 => confirmation des pack selectionne
2 => fin de cette partie 
3 => une erreur est survenue */

  String hubSelectione = "";

  String email;
  String mdp;
  User user;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //final List<Hub> listHubs = Services.getListHubs();

  List<Package> packagesRemetreList = [];
  List<Package> filteredPackagesRemetreList;
  List<Hub> listHubs = [];

  void initState() {
    super.initState();
  }
  String hubName(String id){
    return listHubs.firstWhere((element) => element.id.compareTo(id)==0).name;
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
      Services.getPacakgeARemettre(email, mdp).then((value) {
        setState(() {
          if (value != null) {
            packagesRemetreList = value;
            filteredPackagesRemetreList = packagesRemetreList;
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
                          "Une panne est survenue au niveau du serveur, Veuillez r??essayer plus tard"),
                      actions: [
                        FlatButton(
                            child: Text("Revenir ?? la page d'accueil"),
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
          brightness: Brightness.dark,
          backgroundColor: Colors.purple[900],
          title: Text("Remettre les navettes"),
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
        /*Une barre qui s'affiche  apr??s une clique sur le bouton de filtre pour ex??cuter des filtres*/
        endDrawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                SizedBox(height: 5),
                TitreListeFiltrer(titre: 'Filtrer par hub d\'arriv??e'),
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
                          filteredPackagesRemetreList = packagesRemetreList;
                        });
                      },
                      height: 40,
                      child: Text(
                        'R??initialiser',
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
                          filteredPackagesRemetreList = filtrage(hubSelectione);
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
              child: ShowStepState(state: 3),
            ),
            Flexible(
              child: validationState == -1
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : packagesRemetreList.length == 0
                      ? ListeVideWidget(
                          text: "Aucune package ?? remettre dans votre liste\n")
                      : filteredPackagesRemetreList.length == 0
                          ? ListeVideWidget(
                              text:
                                  "Aucune package ?? remettre pour ce filtre\n")
                          : ListView(
                              padding: EdgeInsets.only(bottom: 60),
                              children: List.generate(
                                  filteredPackagesRemetreList.length, (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  child: Card(
                                    child: ListTile(
                                      onLongPress: () {
                                        setState(() {
                                          //selectingmode = true;
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          //  if (selectingmode) {
                                          filteredPackagesRemetreList[index]
                                                  .selected =
                                              !filteredPackagesRemetreList[
                                                      index]
                                                  .selected;
                                          //}
                                        });
                                      },
                                      selected:
                                          filteredPackagesRemetreList[index]
                                              .selected,
                                      leading: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {},
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.unarchive_rounded,
                                            color: Colors.purple[900],
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      title: Text('ID: ' +
                                          filteredPackagesRemetreList[index]
                                              .id
                                              .toString()),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(right:30.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                          Text(filteredPackagesRemetreList[index]
                                              .status
                                              .toString()),
                                          Text(hubName(
                                              filteredPackagesRemetreList[index]
                                                  .hubArrive))
                                        ]),
                                      ),
                                      trailing:
                                          /*(selectingmode)
                                                    ? */
                                          ((filteredPackagesRemetreList[index]
                                                  .selected)
                                              ? Icon(
                                                  Icons.check_box,
                                                  color: Colors.purple[900]
                                                      .withOpacity(0.9),
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: Colors.purple[900]
                                                      .withOpacity(0.9),
                                                  size: 30,
                                                ))
                                      /*: null*/,
                                    ),
                                  ),
                                );
                              }),
                            ),
            ),
          ],
        ),
        floatingActionButton: MaterialButton(
          onPressed: validationState == -1
              ? null
              : packagesRemetreList.length != 0
                  ? () async {
                      //var connected = await Services.isConnected();
                      if (Home.connected) {
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        var nonSelectione = nbNonSelectionne();
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return WillPopScope(
                                  onWillPop: () => Future.value(false),
                                  child: AlertDialog(
                                    title: Text("Confirmation"),
                                    content: validationState == 0
                                        ? Text.rich(TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    'Vous confirmez la remise de(s) '),
                                            TextSpan(
                                                text:
                                                    '${filteredPackagesRemetreList.length - nonSelectione}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            TextSpan(text: ' package(s) !'),
                                          ]))
                                        : validationState == 1
                                            ? CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.blue))
                                            : validationState == 2
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            ShowStepState
                                                                .valide,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Image.asset(
                                                              "assets/Navette Remise.png",
                                                              semanticLabel:
                                                                  "Navette Remise",
                                                            )), /* Icon(
                                            Icons.local_shipping_outlined,
                                            color: Colors.white,
                                          ),*/
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text.rich(
                                                        TextSpan(children: [
                                                          TextSpan(
                                                              text:
                                                                  "Packages ?? remettre\n",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                          TextSpan(
                                                              text:
                                                                  "Etape Termin??e",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .green,
                                                              ))
                                                        ]),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            ShowStepState
                                                                .nonValide,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Image.asset(
                                                              "assets/Navette Remise.png",
                                                              semanticLabel:
                                                                  "Navette Remise",
                                                            )), /* Icon(
                                            Icons.local_shipping_outlined,
                                            color: Colors.white,
                                          ),*/
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text.rich(
                                                        TextSpan(children: [
                                                          TextSpan(
                                                              text:
                                                                  "Packages ?? remettre\n",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                          TextSpan(
                                                              text:
                                                                  "Etape Echou??e\n",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                          TextSpan(
                                                              text: "Motif : " +
                                                                  validationMessage,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .grey[800],
                                                              ))
                                                        ]),
                                                        textAlign:
                                                            TextAlign.center,
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
                                                if (filteredPackagesRemetreList
                                                            .length -
                                                        nonSelectione !=
                                                    0) {
                                                  validationMessage =
                                                      await Services
                                                          .remiseBienConfirmer(
                                                              email,
                                                              mdp,
                                                              idPackagesRemi());

                                                  setState(() {
                                                    if (validationMessage
                                                            .compareTo("1") ==
                                                        0)
                                                      validationState = 2;
                                                    else
                                                      validationState = 3;
                                                  });
                                                  attente.run(() {
                                                    Navigator.of(context).pop();
                                                    if (validationMessage
                                                            .compareTo("1") ==
                                                        0) {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              '/home/packageRecuperer',
                                                              arguments: {
                                                            'user': user,
                                                            'email': email,
                                                            'mdp': mdp
                                                          });
                                                    } else
                                                      setState(() {
                                                        validationState = 0;
                                                      });
                                                  });
                                                } else {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '/home/packageRecuperer',
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
                    }
                  : () {
                      Navigator.pushReplacementNamed(
                          context, '/home/packageRecuperer', arguments: {
                        'user': user,
                        'email': email,
                        'mdp': mdp
                      });
                    },
          child: Text(
            packagesRemetreList.length != 0 ? "Confirmer" : "Continuer",
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

  List<Package> filtrage(String hubSelectione) {
    return packagesRemetreList
        .where((u) => (hubSelectione.contains('*${u.hubArrive}-')))
        .toList();
  }

  int nbNonSelectionne() {
    return filteredPackagesRemetreList
        .where((element) => element.selected == false)
        .toList()
        .length;
  }

  String idPackagesRemi() {
    String packageSelectione = '';
    filteredPackagesRemetreList.forEach((element) {
      if (element.selected)
        packageSelectione = packageSelectione + "${element.id},";
    });
    return packageSelectione.substring(0, packageSelectione.length - 1);
  }
}
