import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_beep/flutter_beep.dart';

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

class PackageRecuperer extends StatefulWidget {
  @override
  _PackageRecupererState createState() => _PackageRecupererState();
}

class _PackageRecupererState extends State<PackageRecuperer> {
  Attente attente = Attente(milliseconds: 3000);
  int validationState = -1;
  String hubSelectione = "";
  String validationMessage = "";

  String email;
  String mdp;
  User user;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //final List<Hub> listHubs = Services.getListHubs();

  List<Package> packagesRecupererList = [];
  List<Package> filteredPackagesRecupererList;
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
      Services.getPacakgeARecuperer(email, mdp).then((value) {
        setState(() {
          if (value != null) {
            //print("cc");
            packagesRecupererList = value;
            filteredPackagesRecupererList = packagesRecupererList;
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
          brightness: Brightness.dark,
          backgroundColor: Colors.purple[900],
          title: Text("Recuperer les navettes"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                FlutterBarcodeScanner.getBarcodeStreamReceiver(
                        "#5b0781", "Terminé", true, ScanMode.BARCODE)
                    .listen((barcode) {
                  setState(() {
                    var state = miseAJourScan(barcode);
                    state == 1 ? FlutterBeep.beep() : FlutterBeep.beep(false);
                  });
                });
                /*
                Un par Un
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                                                    "#5b0781", "Cancel", false, ScanMode.BARCODE);
                                                    setState(() {
                    var state = miseAJourScan(barcode) ;
                        showSimpleNotification(
    Text(state==-1?"Ce pacakge n'existe pas dans votre liste":state==0?"Package déja scanné":"Package scanné"),
    background: state==-1?Colors.red.withOpacity(0.8):state==0?Colors.purple[900].withOpacity(0.8):Colors.green.withOpacity(0.8), position: NotificationPosition.bottom);
                    });*/
              },
              icon: Icon(Icons.qr_code_scanner_rounded,
                  size: 25, color: Colors.white),
            ),
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
                TitreListeFiltrer(titre: 'Filtrer par hub de depart'),
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
                          filteredPackagesRecupererList = packagesRecupererList;
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
                          filteredPackagesRecupererList =
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
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.help,
                      size: 25,
                      color: Colors.indigo,
                      semanticLabel: "Aide",
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Aide",
                      style: TextStyle(
                        color: Colors.purple[900],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.purple[900].withOpacity(0.8),
                          ),
                          SizedBox(width: 5),
                          Text("Package scanné valide"),
                        ],
                      ),
                      subtitle: Text(
                          "Le son lancé lorsque le package est bien scanné"),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: Colors.purple[900].withOpacity(0.9),
                        ),
                        onPressed: () {
                          FlutterBeep.beep();
                        },
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            Icons.highlight_remove_rounded,
                            color: Colors.purple[900].withOpacity(0.8),
                          ),
                          SizedBox(width: 5),
                          Text("Package scanné invalide"),
                        ],
                      ),
                      subtitle: Text(
                          "Le son lancé lorsque le package est déja scanné ou n'apparait pas dans la liste"),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: Colors.purple[900].withOpacity(0.9),
                        ),
                        onPressed: () {
                          FlutterBeep.beep(false);
                        },
                      ),
                    )
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
              child: ShowStepState(state: 4),
            ),
            Flexible(
              child: validationState == -1
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : packagesRecupererList.length == 0
                      ? ListeVideWidget(
                          text: "Aucune package à Recuperer dans votre liste\n")
                      : filteredPackagesRecupererList.length == 0
                          ? ListeVideWidget(
                              text:
                                  "Aucune package à Recuperer pour ce filtre\n")
                          : ListView(
                              padding: EdgeInsets.only(bottom: 60),
                              children: List.generate(
                                  filteredPackagesRecupererList.length,
                                  (index) {
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
                                          /*if (filteredPackagesRecupererList[
                                                  index]
                                              .selected)*/
                                          filteredPackagesRecupererList[index]
                                                  .selected =
                                              !filteredPackagesRecupererList[
                                                      index]
                                                  .selected;
                                          //}
                                        });
                                      },
                                      selected:
                                          filteredPackagesRecupererList[index]
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
                                            Icons.archive_rounded,
                                            color: Colors.purple[900],
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      title: Text('ID: ' +
                                          filteredPackagesRecupererList[index]
                                              .id
                                              .toString()),
                                      subtitle: Padding(padding:const EdgeInsets.only(right:30.0), 
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              filteredPackagesRecupererList[index]
                                                  .status
                                                  .toString()),
                                          Text(hubName(filteredPackagesRecupererList[index].hubArrive)) ,
                                        ],
                                      ),),
                                      trailing:
                                          /*(selectingmode)
                                                    ? */
                                          ((filteredPackagesRecupererList[index]
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
          onPressed:validationState == -1? null :
           packagesRecupererList.length != 0
              ? () async {
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
                                                'Vous confirmez la récupération de(s) '),
                                        TextSpan(
                                            text:
                                                '${filteredPackagesRecupererList.length - nonSelectione}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(text: ' package(s) !'),
                                      ]))
                                    : validationState == 1
                                        ? CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue))
                                        : validationState == 2
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        ShowStepState.valide,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Image.asset(
                                                        "assets/Navette Récupération.png",
                                                        semanticLabel:
                                                            "Navette récuperation",
                                                      ), /*Icon(
                                            Icons.local_shipping_rounded,
                                            color: Colors.white,
                                          ),*/
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text.rich(
                                                      TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "Packages à récuperer\n",
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
                                                          TextAlign.center),
                                                ],
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        ShowStepState.nonValide,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Image.asset(
                                                        "assets/Navette Récupération.png",
                                                        semanticLabel:
                                                            "Navette récuperation",
                                                      ), /* Icon(
                                            Icons.local_shipping_outlined,
                                            color: Colors.white,
                                          ),*/
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text.rich(
                                                    TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              "Packages à récuperer\n",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                      TextSpan(
                                                          text:
                                                              "Etape Echouée\n",
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
                                                            color: Colors
                                                                .grey[800],
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
                                            if (filteredPackagesRecupererList
                                                        .length -
                                                    nonSelectione !=
                                                0) {
                                              validationMessage = await Services
                                                  .recuperationBienConfirmer(
                                                      email,
                                                      mdp,
                                                      idPackagesRecupere());

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
                                                    0)
                                                  Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                          '/home'));
                                                else
                                                  setState(() {
                                                    validationState = 0;
                                                  });
                                              });
                                            } else
                                              Navigator.popUntil(context,
                                                  ModalRoute.withName('/home'));
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
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
          child: Text(
            packagesRecupererList.length != 0 ? "Confirmer" : "Continuer",
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
    return packagesRecupererList
        .where((u) => (hubSelectione.contains('*${u.hubDepart}-')))
        .toList();
  }

  int nbNonSelectionne() {
    return filteredPackagesRecupererList
        .where((element) => element.selected == false)
        .toList()
        .length;
  }

  String idPackagesRecupere() {
    String packageSelectione = '';
    filteredPackagesRecupererList.forEach((element) {
      if (element.selected)
        packageSelectione = packageSelectione + "${element.id},";
    });

    return packageSelectione.substring(0, packageSelectione.length - 1);
  }

  int miseAJourScan(String barcode) {
    int state = -1;
    filteredPackagesRecupererList.forEach((element) {
      if (barcode.contains(element.id)) {
        state++;
        if (!element.selected) state++;
        element.selected = true;
      }
    });

    return state;
  }
}
