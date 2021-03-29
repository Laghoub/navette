import 'package:flutter/material.dart';

class TitreListeFiltrer extends StatelessWidget {
  final String titre ;

  TitreListeFiltrer({this.titre }) ;

  @override
  Widget build(BuildContext context) {
    return Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      semanticLabel: 'Filtrer par hub',
                      size: 25,
                      color: Colors.indigo,
                    ),
                    SizedBox(width: 10),
                    Text(
                      titre,
                      style: TextStyle(
                        color: Colors.purple[900],
                        fontSize: 15,
                      ),
                    )
                  ],
                );
  }
}