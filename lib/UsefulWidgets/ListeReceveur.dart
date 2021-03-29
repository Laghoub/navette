import 'package:flutter/material.dart';

class ListeReceveur extends StatefulWidget {
  final List liste;
  static int selectedIndex = 0;

  ListeReceveur({this.liste});

  @override
  _ListeReceveurState createState() => _ListeReceveurState();
}

class _ListeReceveurState extends State<ListeReceveur> {
  @override
  void initState() {
    widget.liste[ListeReceveur.selectedIndex].selected = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'Veuillez choisir la personne qui confirme le dépot des enveloppes',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        Flexible(
          child: ListView(
            padding: EdgeInsets.only(bottom: 60),
            children: List.generate(widget.liste.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
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
                        widget.liste[ListeReceveur.selectedIndex].selected =
                            false;
                        ListeReceveur.selectedIndex = index;
                        widget.liste[index].selected = true;
                        //}
                      });
                    },
                    selected: widget.liste[index].selected,
                    leading: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Container(
                        width: 48,
                        height: 48,
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person,
                          color: Colors.purple[900],
                          size: 25,
                        ),
                      ),
                    ),
                    title: Text(widget.liste[index].nom.toUpperCase() +
                        ' ' +
                        widget.liste[index].prenom.toUpperCase()),
                    subtitle: Text(widget.liste[index].id),
                    trailing:
                        /*(selectingmode)
                                                          ? */
                        ((widget.liste[index].selected)
                            ? Icon(
                                Icons.radio_button_checked_outlined,
                                color: Colors.purple[900].withOpacity(0.9),
                                size: 30,
                              )
                            : Icon(
                                Icons.radio_button_unchecked_outlined,
                                color: Colors.purple[900].withOpacity(0.9),
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
    );
  }
}
