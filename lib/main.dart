import 'package:app_workflow_compras/view/LoginScreen.dart';
import 'package:app_workflow_compras/view/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//void main() => runApp(WorkFlow());
void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(LoginScreen());
}

class WorkFlow extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'App Protheus',
      theme: ThemeData.dark(),
      /*theme: ThemeData(
        primarySwatch: Colors.blue,
      ),*/
      home: MainScreen(),
    );
  }
}
