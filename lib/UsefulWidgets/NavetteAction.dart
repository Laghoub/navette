import 'package:flutter/material.dart';

class NavetteAction extends StatelessWidget {
  final String montant;
  final String nbPackageARecuperer;
  final String nbPackageARemettre;

  const NavetteAction(
      {Key key,
      this.montant,
      this.nbPackageARemettre,
      this.nbPackageARecuperer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: Colors.purple[900].withOpacity(0.85),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "DA",
                  style: TextStyle(
                    color: Colors.blue[100],
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "${this.montant}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
            child: Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            color: Colors.purple[900].withOpacity(0.85),
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.unarchive_rounded,
                color: Colors.blue[200],
                size: 23,
              ),
              Text(
                this.nbPackageARemettre,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        )),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: Colors.purple[900].withOpacity(0.85),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.archive_rounded,
                  color: Colors.blue[200],
                  size: 23,
                ),
                Text(
                  this.nbPackageARecuperer,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
