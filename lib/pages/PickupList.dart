import 'package:flutter/material.dart';
import 'package:navette_application/Service/Attente.dart';
import 'package:navette_application/Service/Navette.dart';
import 'package:navette_application/Service/Services.dart';
import 'package:navette_application/Service/User.dart';
import 'package:navette_application/UsefulWidgets/NavetteAction.dart';
import 'package:navette_application/UsefulWidgets/welcomeTitle.dart';

class PickupList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<PickupList> {
  final Attente _attente = Attente(milliseconds: 400);
  User user;
  List<Navette> allListPickup;
  List<Navette> filteredListPickup;

  FocusNode filterFocus = new FocusNode();

  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    filterFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /*Map data = ModalRoute.of(context).settings.arguments;
    print(data);

    user = User(
        id: data['user'].id,
        nom: data['user'].nom,
        prenom: data['user'].prenom,
        role: data['user'].role,
        telephone: data['user'].telephone);*/
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.purple[900],
          appBar: AppBar(
            automaticallyImplyLeading: false ,
              bottomOpacity: 0.1,
              title: Text("Liste des hubs"),
              centerTitle: true,
              backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: SizedBox(
                          child: WelcomeTitle(
                              text:
                                  'Youcef Mouaci') /*"${user.nom.toUpperCase()} ${user.prenom}"),*/
                          ),
                    ),
                    Container(
                      color: Colors.grey[200].withOpacity(0.4),
                      margin : EdgeInsets.all(5) ,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.purple[900],
                        ),
                        focusNode: filterFocus,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          helperText: 'Oran, Tlemcen, Alger, Setif, Annaba',
                          helperStyle: TextStyle(
                            fontSize: 10.0,
                          ),
                          hintText: 'Filtre avec hub d' 'arriver',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 17,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.purple[900].withOpacity(0.6)),
                          ),
                        ),
                        onChanged: (string) {
                          _attente.run(() {
                            setState(() {
                              filteredListPickup = allListPickup
                                  .where((u) => (u.hubFinale.contains(string)))
                                  .toList();
                              print(filteredListPickup);
                            });
                          });
                        },
                      ),
                    ),
                    Flexible(
                        child: allListPickup.length > 1
                            ? ListView.builder(
                                //key: _listKey,
                                itemCount: filteredListPickup.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.purple[50].withOpacity(0.4),
                                      border: Border.all(
                                          color: Colors
                                              .transparent, // set border color
                                          width: 0.8), // set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              10.0)), // set rounded corner radius
                                    ),
                                    child: ListTile(
                                      selectedTileColor: Colors.purple[900],
                                      onTap: () {
                                        filterFocus.unfocus();
                                        //print("click");
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Details(navette: navette)));
                                      },
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(filteredListPickup[index].titre,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[300])),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                              '${filteredListPickup[index].hubDepart} vers ${filteredListPickup[index].hubFinale}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey[600])),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          NavetteAction(
                                              montant:
                                                  allListPickup[index].montant,
                                              nbPackageARemettre:
                                                  '${filteredListPickup[index].nbPackageARemettre}',
                                              nbPackageARecuperer:
                                                  '${filteredListPickup[index].nbPackageARecuperer}'),
                                        ],
                                      ),
                                      trailing:
                                          Text(filteredListPickup[index].date),
                                    ),
                                  );
                                })
                            : Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: Center(
                                  child: Text(
                                    "Aucune navette dans votre liste,\n à bien tot!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          Colors.purple[900].withOpacity(0.90),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )))
                    //Sandbox(),
                  ],
                )),
          )),
    );
  }
}
