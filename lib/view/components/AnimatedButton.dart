import 'package:flutter/material.dart';

class MistralAnimatedButton extends StatefulWidget {
  MistralAnimatedButton({Key key}) : super(key: key);

  @override
  MistralAnimatedButtonAnimation createState() => MistralAnimatedButtonAnimation();
}

class MistralAnimatedButtonAnimation extends State<MistralAnimatedButton> {
  bool selected = false;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(300);

  double before = 200;
  double after = 220;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Center(
        child: AnimatedContainer(
          width: selected ? after : before,
          height: selected ? after : before,
          //color: selected ? Colors.red : Colors.blue,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Image(image: AssetImage('lib/view/assets/mistral_logo.png')),
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: selected ? Colors.grey : Colors.orangeAccent,
          ),
        ),
      ),
    );
  }
}