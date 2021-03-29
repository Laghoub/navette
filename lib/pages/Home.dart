//import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:navette_application/Service/Hub.dart';
import 'package:navette_application/Service/Services.dart';
import 'package:navette_application/Service/User.dart';
import 'package:navette_application/UsefulWidgets/HomeScreen.dart';
import 'package:navette_application/UsefulWidgets/ProfileScreen.dart';

class Home extends StatefulWidget {
  static bool connected = true;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>() ;

  
  var listener ;

  User user;
  String email;
  String mdp;

  int _currentIndex = 0;
  List<Widget> _children;

  @override
  void didChangeDependencies() {
    Map data = ModalRoute.of(context).settings.arguments;
    email = data['email'] as String;
    user = data['user'] as User;
    mdp = data['mdp'] as String;
    _children = [
      HomeScreen(user: user, email: email, mdp: mdp,scaffoldKey: _scaffoldKey,),
      ProfileScreen(user: user, email: email, mdp: mdp),
    ];
    //print(user) ;
    //print(email);
    //print(mdp);

   
   //test continue de connexion ...
   listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        Home.connected = true ;
        break;
      case DataConnectionStatus.disconnected:
        Home.connected = false ;
        break;
    }
  });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[900],
      child: SafeArea(
        child: Scaffold(
          key : _scaffoldKey ,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.purple[900],
            title: Text("Espace Navette"),
            centerTitle: true,
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
                        elevation: 0.0,
              onTap: onTabTapped,
              selectedItemColor: Colors.purple[800],
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: new Icon(
                      Icons.home,
                    ),
                    label: "Acceuil"),
                BottomNavigationBarItem(
                    icon: new Icon(Icons.account_circle), label: "Profile"),
              ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
               //var connected = await Services.isConnected();
               if(Home.connected){
              Navigator.pushNamed(context, '/home/enveloppeRemettre',
                  arguments: {'user': user, 'email' : email, 'mdp': mdp});
                  
              _scaffoldKey.currentState.removeCurrentSnackBar() ;}
                  else{
              _scaffoldKey.currentState.removeCurrentSnackBar() ;
                    Services.showNoConnectionSnackBar(_scaffoldKey) ;
                  }
            },
            tooltip: "Commencer",
            child: Icon(Icons.arrow_forward, color: Colors.indigo, size: 25),
            elevation: 2.0,
            backgroundColor: Colors.white,
          ),
          body: _children[_currentIndex],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
