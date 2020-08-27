
import 'package:flutter/material.dart';

import 'MenuPrincipal.dart';
import 'components/AnimatedButton.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Protheus'),
      ),
      drawer: MenuPrincipal(
        isHome: true,
      ),
      body: Container(
        /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/flutter_logo.png"),
              fit: BoxFit.cover,
            ),
          ),*/
        child: MistralAnimatedButton(),
      ),
    );
  }
}
