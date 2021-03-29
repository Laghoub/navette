import 'package:flutter/material.dart';

class SmsCodeConfirmationWid extends StatefulWidget {
  
  static GlobalKey<FormState> keyform = GlobalKey<FormState>() ;
  static TextEditingController smsCodeController = TextEditingController();
  static bool nonValidated = false;

  @override
  _SmsCodeConfirmationWidState createState() => _SmsCodeConfirmationWidState();
}

class _SmsCodeConfirmationWidState extends State<SmsCodeConfirmationWid> {
  FocusNode smsCodeFocus = FocusNode();
  @override
  void initState() {
    //SmsCodeConfirmationWid.nonValidated = false ;
    super.initState();
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
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Confirmation par le code de vérification",
              textAlign : TextAlign.center ,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.purple[900].withOpacity(0.7),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal : 25),
            child: Form(
              key:SmsCodeConfirmationWid.keyform,
                          child: TextFormField(
                

                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: SmsCodeConfirmationWid.smsCodeController,
                focusNode: smsCodeFocus,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez entrer le code reçu';
                  }
                  if (SmsCodeConfirmationWid.nonValidated) {
                    return "Le code introduit n'est pas valide";
                  }
                  return null;
                },
                style: TextStyle(
                    color: Colors.purple[900].withOpacity(0.95),
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Colors.purple[900].withOpacity(0.6)),
                  ),
                  hintText: "Code",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
