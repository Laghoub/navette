import 'package:flutter/material.dart';

class ListeEnveloppeFiltrer extends StatefulWidget {
  final List liste;

  ListeEnveloppeFiltrer({this.liste});

  @override
  _ListeEnveloppeFiltrerState createState() => _ListeEnveloppeFiltrerState();
}

class _ListeEnveloppeFiltrerState extends State<ListeEnveloppeFiltrer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
                  widget.liste[index].selected = !widget.liste[index].selected;
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
                    Icons.attach_money_rounded,
                    color: Colors.purple[900],
                    size: 25,
                  ),
                ),
              ),
              title: Text('ID: ' + widget.liste[index].id),
              subtitle: Text(widget.liste[index].montant+ ' Da'),
              trailing:
                  /*(selectingmode)
                                                    ? */
                  ((widget.liste[index].selected)
                      ? Icon(
                          Icons.check_box,
                          color: Colors.purple[900].withOpacity(0.9),
                          size: 30,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.purple[900].withOpacity(0.9),
                          size: 30,
                        ))
              /*: null*/,
            ),
          ),
        );
      }),
    );
  }
}
