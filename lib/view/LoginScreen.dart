import 'package:app_workflow_compras/controller/GlobalConfigurations.dart';
import 'package:app_workflow_compras/controller/WSLogin.dart';
import 'package:app_workflow_compras/model/UsuarioProtheus.dart';
import 'package:app_workflow_compras/view/MainScreen.dart';
import 'package:app_workflow_compras/view/components/AnimatedButton.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'delayed_animation.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  TextEditingController loginController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  AvatarGlow(
                    endRadius: 90,
                    duration: Duration(seconds: 2),
                    glowColor: Colors.white,
                    repeat: true,
                    repeatPauseDuration: Duration(seconds: 2),
                    startDelay: Duration(seconds: 1),
                    child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: MistralAnimatedButton(),
                          radius: 50.0,
                        )),
                  ),
                  DelayedAimation(
                    child: Text(
                      "Bem vindo(a)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: color),
                    ),
                    delay: delayedAmount + 2000,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  DelayedAimation(
                    child: Text(
                      "Protheus App",
                      style: TextStyle(fontSize: 25.0, color: color),
                    ),
                    delay: delayedAmount + 3000,
                  ),
                  DelayedAimation(
                    child: Text(
                      "Mistral Tecnologia",
                      style: TextStyle(fontSize: 15.0, color: color),
                    ),
                    delay: delayedAmount + 3000,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  DelayedAimation(
                    child: GestureDetector(
                      child: Transform.scale(
                        scale: _scale,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: TextField(
                                    controller: loginController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Usuário',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(60, 0, 60, 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: TextField(
                                    controller: senhaController,
                                    textAlign: TextAlign.center,
                                    obscureText: true,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Senha',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            _animatedButtonUI(context),
                          ],
                        ),
                      ),
                    ),
                    delay: delayedAmount + 4000,
                  ),
                  /*SizedBox(
                    height: 50.0,
                  ),
                  DelayedAimation(
                    child: Text(
                      "I Already have An Account".toUpperCase(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    delay: delayedAmount + 5000,
                  ),*/
                ],
              ),
            )
            //  Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text('Tap on the Below Button',style: TextStyle(color: Colors.grey[400],fontSize: 20.0),),
            //     SizedBox(
            //       height: 20.0,
            //     ),
            //      Center(

            //   ),
            //   ],

            // ),
            ),
      ),
    );
  }

  Widget _animatedButtonUI(BuildContext context) => GestureDetector(
        onTap: () {
          fetchUser(context);
        },
        child: Container(
          height: 50,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
        ),
      );

  Future<Post> fetchUser(BuildContext context) async {
    UsuarioProtheus usuarioProtheus;
    String retorno;
    String login = loginController.text;
    String senha = senhaController.text;

    if (login.isEmpty) {
      Toast.show("Informe o Usuário", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    } else if (senha.isEmpty) {
      Toast.show("Informe a Senha", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }

    Toast.show('Logando...', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    final response = await WSLogin(login, senha);
    if (response != null) {
      retorno = response.body['RETORNO'];
      if (retorno == 'OK') {
        usuarioProtheus = UsuarioProtheus(
            response.body['USUARIO'][0]['CODIGO'],
            response.body['USUARIO'][0]['LOGIN'],
            response.body['USUARIO'][0]['NOME'],
            response.body['USUARIO'][0]['EMAIL']);

        GlobalConfigurations.usuarioProtheus = usuarioProtheus;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        Toast.show(retorno, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show("Internal Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
