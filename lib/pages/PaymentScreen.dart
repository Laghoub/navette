import 'package:flutter/material.dart' ;

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  List<Payment> paymentList =  [
    Payment(id :1, montant : 1000, selected : true),
    Payment(id :2, montant : 1000, selected : false),

    ];


  @override
  Widget build(BuildContext context) {
    return Container(
      
      child : Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor : Colors.purple[900] ,
          /*leading: selectingmode
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      selectingmode = false;
                      paints.forEach((p) => p.selected = false);
                    });
                  },
                )
              : null,*/
          title: Text("Enveloppe"),
          centerTitle : true ,
          actions: [
            TextButton(onPressed: null, child: Text(
              "Suivant",
              style : TextStyle( color: Colors.white,
              fontSize: 17.0 ,
            
            ))) ,
          ],
        ),
        body: ListView(
          children: List.generate(paymentList.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical : 3, horizontal : 7),
              child: ListTile(
                onLongPress: () {
                  setState(() {
                    //selectingmode = true;
                  });
                },
                onTap: () {
                  setState(() {
                  //  if (selectingmode) {
                      paymentList[index].selected = !paymentList[index].selected;
                      print(paymentList[index].selected.toString());
                    //}
                  });
                },
                selected: paymentList[index].selected,
                leading: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Container(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: Icon(Icons.attach_money_rounded,
                    color: Colors.blue,
                     // backgroundColor: paints[index].colorpicture,
                    ),
                  ),
                ),
                title: Text('ID: ' + paymentList[index].id.toString()),
                subtitle: Text(paymentList[index].montant.toString()),
                trailing: /*(selectingmode)
                    ? */((paymentList[index].selected)
                        ? Icon(Icons.check_box, color: Colors.purple[900].withOpacity(0.9),)
                        : Icon(Icons.check_box_outline_blank,color: Colors.purple[900].withOpacity(0.9),))
                    /*: null*/,
              ),
            );
          }),
        ),
      ),

    
    
      
    );
  }
}


class Payment {
  int id ;
  int montant ;
  bool selected ;

  Payment({this.id, this.montant, this.selected}) ;
}