import 'package:flutter/material.dart' ;

class ProfilItem extends StatelessWidget {
  final String titre ;
  final String detail ;

  ProfilItem({this.titre, this.detail}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child :  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          Text(
            titre ,
            style : TextStyle(
              color:Colors.grey ,
              fontSize: 13
            )
          ),
          
          Text(
            detail ,
            style : TextStyle(
              color:Colors.grey[900] ,
              fontSize: 18
            ),
          ),
          SizedBox(height: 5,),
          Divider(
            color : Colors.grey[800].withOpacity(0.8) ,
            height: 2 ,
            thickness: 1 ,
          ),
          SizedBox(height : 10)
        ],
      )
      
    );
  }
}