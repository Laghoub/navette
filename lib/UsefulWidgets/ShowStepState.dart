import 'package:flutter/material.dart';
/*trois bulle définissons l'etape achevé par le chauffeur 
1.retour et récuperation des enveloppes 
2.remmettre des packages
3.recuperer des packages
*/ 
class ShowStepState extends StatelessWidget {

  final int state;

  ShowStepState({this.state});

  static Color encour = Colors.purple[900].withOpacity(0.8);
  static Color valide = Colors.green.withOpacity(0.8);
  static Color enattente = Colors.grey.withOpacity(0.8) ;
static Color nonValide = Colors.red.withOpacity(0.8);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor:state==1?encour: valide,
            child : Stack
            (children : [
              Icon(Icons.money, color: Colors.white,) ,
              Positioned(
                bottom : 2.0 ,
                child : Icon(Icons.arrow_drop_up, color: Colors.white,size: 35,) 
              )
              ], 
            ),
          ),
          Container(
            width: 40,
            height: 2.0,
            color: Colors.blueAccent ,
          ),
           CircleAvatar(
            backgroundColor:state==1?enattente:state==2? encour: valide ,
            child : Stack
            (children : [
              Icon(Icons.money, color: Colors.white,) ,
              Positioned(
                top : 2.0 ,
                child : Icon(Icons.arrow_drop_down, color: Colors.white,size: 35) 
              )
              ], 
            ),
          ),
          Container(
            width: 40,
            height: 2.0,
            color: Colors.blueAccent ,
          ),
          CircleAvatar(
            backgroundColor: state==3?encour:state<3? enattente: valide,
            child : Icon(Icons.local_shipping_outlined, color: Colors.white,),
          ),
          Container(
            width: 40,
            height: 2.0,
            color: Colors.blueAccent ,
          ),
          CircleAvatar(
            backgroundColor: state==4?encour: state <4? enattente : valide,
            child : Icon(Icons.local_shipping_rounded, color: Colors.white,),
          ),
        
        ],
      ),
    );
  }
}