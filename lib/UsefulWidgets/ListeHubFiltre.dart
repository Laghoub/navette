import 'package:flutter/material.dart';

class ListeHubFiltre extends StatefulWidget {
  final listHubs;

  ListeHubFiltre({this.listHubs});

  @override
  _ListeHubFiltreState createState() => _ListeHubFiltreState();
}

class _ListeHubFiltreState extends State<ListeHubFiltre> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: List.generate(widget.listHubs.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: ListTile(
              onLongPress: () {
                setState(() {
                  //selectingmode = true;
                });
              },
              onTap: () {
                setState(() {
                  //  if (selectingmode) {
                  widget.listHubs[index].selected = !widget.listHubs[index].selected;
                  //}
                });
              },
              selected: widget.listHubs[index].selected,
              leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  width: 48,
                  height: 48,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_city_sharp,
                    color: (widget.listHubs[index].selected)
                        ? Colors.purple[900]
                        : Colors.grey[800],
                    // backgroundColor: paints[index].colorpicture,
                  ),
                ),
              ),
              title: Text(widget.listHubs[index].nomVille.toUpperCase()),
              subtitle: Text('ID: ' + widget.listHubs[index].id.toString()),
              trailing:
                  /*(selectingmode)
                      ? */
                  ((widget.listHubs[index].selected)
                      ? Icon(
                          Icons.check_box,
                          color: Colors.purple[900].withOpacity(0.9),
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.purple[900].withOpacity(0.9),
                        ))
              /*: null*/,
            ),
          );
        }),
      ),
    );
  }
}
