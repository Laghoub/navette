import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:navette_application/Globals/globals.dart';
import 'package:navette_application/Service/Enveloppe.dart';
import 'package:navette_application/Service/Package.dart';
import 'Hub.dart';
import 'dart:convert';
import 'User.dart';

class Services {
  // devServeur = '51.91.56.9:2021' ;
  // preprodServeur = 'pre-prod.easy-relay.com' ;
  // prodServeur = 'bo.easy-relay.com' ;
   
  static  String nomServeur = 'bo.easy-relay.com' ;
  static String nomMob = 'mob2';
//pour recuperation des user donnée -Login
  static Future<User> userLogin(String email, String mdp) async {
    String url = "https://$nomServeur/api/$nomMob/api.php?action=login";

    try {
      final reponse =
          await get(url, headers: <String, String>{"email": email, "mdp": mdp});
      if (reponse.statusCode == 200) {
        final reponseJson = jsonDecode(reponse.body);
        print(reponseJson);
        if (reponseJson.containsKey("error")) {
          return User(id: "-1"); //user n'existe pas
        }
        return User.fromJson(reponseJson);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      print(e);
      return User(id: "-2"); //erreur dans le serveur pendant login user
    }
  }

//por test de connexion
  static Future<bool> isConnected() async {
    bool connected = await DataConnectionChecker().hasConnection;

    return connected;
  }

  static showNoConnectionSnackBar(GlobalKey<ScaffoldState> _scaffoldKey) {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey[100].withOpacity(0.95),
      content: Text(
        'Vérifier votre connexion internet!',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      action: SnackBarAction(
        textColor: Colors.indigo,
        label: 'Ok',
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
/*
  static Future<List<Navette>> getNavettes() async {
    try {
      final response = await https.get(url);
      if (response.statusCode == 200) {
        List<Navette> list = parseNavette(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 
  static List<Navette> parseNavette(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Navette>((json) => Navette.fromJson(json)).toList();
  }



//  la liste des hubs
  static List<Hub> getListHubs() {
    return [
      Hub(id: '10', nomVille: 'Alger'),
      Hub(id: '12', nomVille: 'Oran'),
      Hub(id: '14', nomVille: 'Tlemcen'),
      Hub(id: '15', nomVille: 'Setif'),
      Hub(id: '16', nomVille: 'Anaba'),
    ];
  }
*/
  static Future<List<Hub>> getListHubs(
      String email, String mdp) async {
    try {
      String url =
          "https://$nomServeur/api/$nomMob/api.php?action=list_hub";
      final response = await get(url, headers: <String, String>{
        'email': email,
        'mdp': mdp,
      });
      if (response.statusCode == 200) {
        List<Hub> list = parseHub(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Package>> getPacakgeARemettre(
      String email, String mdp) async {
    try {
      String url =
          "https://$nomServeur/api/$nomMob/api.php?action=navettes_EN_COURS";
      final response = await get(url, headers: <String, String>{
        'email': email,
        'mdp': mdp,
      });
      if (response.statusCode == 200) {
        
        print(response.body) ;
        List<Package> list = parsePackage(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Package>> getPacakgeARecuperer(
      String email, String mdp) async {
    try {
      String url =
          "https://$nomServeur/api/$nomMob/api.php?action=navettes_EN_ATTENTE";
      final response = await get(url, headers: <String, String>{
        'email': email,
        'mdp': mdp,
      });
      if (response.statusCode == 200) {
        
        List<Package> list = parsePackage(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> remiseBienConfirmer(
      String email, String mdp, String ids) async {
    try {
      var headers = {
        'email': email,
        'mdp': mdp,
        'Content-Type': 'application/json'
      };
      var request = Request('GET',
          Uri.parse('https://$nomServeur/api/$nomMob/api.php?action=return'));
      request.body = '''[$ids]''';
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return response.reasonPhrase;
      }
    } catch (e) {
      return 'Serveur planté';
    }
  }

  static Future<String> recuperationBienConfirmer(
      String email, String mdp, String ids) async {
    try {
      var headers = {
        'email': email,
        'mdp': mdp,
        'Content-Type': 'application/json'
      };
      var request = Request('GET',
          Uri.parse('https://$nomServeur/api/$nomMob/api.php?action=departure'));
      request.body = '''[$ids]''';
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return response.reasonPhrase;
      }
    } catch (e) {
      return 'Serveur planté';
    }
  }

  static List<Package> parsePackage(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Package>((json) => Package.fromJson(json)).toList();
  }
/*
  static void test() {
    String packageSelectione = '';
    List<Package> list = [
      Package(id: "1223", selected: true),
      Package(id: "2345", selected: false),
      Package(id: "432", selected: false),
      Package(id: "4232", selected: true),
    ];
    list.forEach((element) {
      if (element.selected)
        packageSelectione = packageSelectione + "${element.id},";
    });

    print(
        '''[${packageSelectione.substring(0, packageSelectione.length - 1)}]''');
  }*/

  static Future<bool> envoiCodeCofirmation(
      {String moyen,
      String email,
      String mdp,
      String tel,
      String emailreceveur,
      String ids}) async {
    String url =
        "https://$nomServeur/api/$nomMob/api.php?action=codeTransfertCaisse&moyen=$moyen";

    print(emailreceveur +" "+tel+" "+email+mdp);
    var headers = {
      'email': email, //'bilel@er.com'
      'mdp':mdp , //'0597'
      'tel': tel, //'0790479950'
      'emailreceveur': emailreceveur //'nada.g@easy-relay.com'
    };
    try {
      var request = MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({'ids': ids /*'13,14' */});

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String sResponse = await response.stream.bytesToString();
        if (sResponse.contains("error"))
          return false;
        else if (sResponse.contains("false"))
          return false;
        else
          return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> confirmeCode(
      {String email, String mdp, String codeconfirmation, String ids}) async {
    String url =
        "https://$nomServeur/api/$nomMob/api.php?action=confirmertransfertcaisse";

    var headers = {
      'email': email, //'bilel@er.com'
      'mdp': mdp, //'0597'
      'codeconfirmation': codeconfirmation,
    };
    try {
      var request = MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({'ids': ids /*'13,14'*/});

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String sResponse = await response.stream.bytesToString();
        if (sResponse.contains("error"))
          return false;
        else if (sResponse.contains("false"))
          return false;
        else
          return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Enveloppe>> getEnveloppeARemettre(
      String email, String mdp, String id) async {
    String url =
        "https://$nomServeur/api/$nomMob/api.php?action=getTransfertNavette";
    try {
      var headers = {
        'email': email, //'bilel@er.com'
        'mdp': mdp, //'0597'
        'etat': '3',
        'acteur': id , //385494
      };
      var request = Request('GET', Uri.parse(url));

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String sResponse = await response.stream.bytesToString();
        print(sResponse);
        List<Enveloppe> list = parseEnveloppe(sResponse);
        return list;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Enveloppe>> getEnveloppeARecuperer(
      String email, String mdp, String id) async {
    String url =
        "https://$nomServeur/api/$nomMob/api.php?action=getTransfertNavette";
    try {
      var headers = {
        'email': email, //'bilel@er.com'
        'mdp':mdp , //'0597'
        'etat': '1',
        'acteur': id, //'385494'
      };
      var request = Request('GET', Uri.parse(url));

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String sResponse = await response.stream.bytesToString();
        List<Enveloppe> list = parseEnveloppe(sResponse);
        return list;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return null;
    }
  }

  static List<Enveloppe> parseEnveloppe(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Enveloppe>((json) => Enveloppe.fromJson(json)).toList();
  }
  static List<Hub> parseHub(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Hub>((json) => Hub.fromJson(json)).toList();
  }

  static Future<String> setStateEnveloppe(
      String email, String mdp, String ids, String id) async {
    String url =
        "https://$nomServeur/api/$nomMob/api.php?action=setTransfertActeurEtat";
    try {
      var headers = {
        'email': email,//'bilel@er.com'
        'mdp':mdp ,//'0597'
        'id': ids,//ids
        'etat': '3',//state
        'acteur':id //'385494'
      };
      var request = Request('GET', Uri.parse(url));

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return (await response.stream.bytesToString());
      } else {
        return response.reasonPhrase ;
      }
    } catch (e) {
      return "Serveur Planté";
    }
  }




}
