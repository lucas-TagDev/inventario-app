import 'package:inventario/screens/register.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/create.dart';
import 'screens/detalhes.dart';
import 'screens/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/screens/login.dart';
//import 'package:localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:inventario/screens/tabs/pages/tabs_pages.dart';

void main() => runApp(App());


class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: CheckAuth(),
      title: 'Inventario',
      debugShowCheckedModeBanner: false,
      //initialRoute: '/',
      routes: {
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        //'/': (context) => CheckAuth(),
        '/home': (context) => Home(),
        '/create': (context) => Create(),
        '/details': (context) => Details(),
        '/edit': (context) => Edit(),
      },
    );
  }
}
class CheckAuth extends StatefulWidget{
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth>{
  bool isAuth = false;

  @override
  void initState(){
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      if(mounted){
        setState(() {
          isAuth = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    Widget child;
    if(isAuth){
      child = TabsPage();
    } else{
      child = Login();
    }

    return Scaffold(
      body: child,
    );
  }
}