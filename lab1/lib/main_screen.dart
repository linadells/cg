import 'package:flutter/material.dart';
import 'canva.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'control_pannel.dart';
import 'styles.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late myCanva canva;
  @override
  void initState() {
    super.initState();
    canva=myCanva();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            child: DefaultTextStyle(
              child: AnimatedTextKit(
                animatedTexts: [TypewriterAnimatedText('Parallelogram')],
              ),
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 40.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: kFrame,
                        child: CustomPaint(
                            size: Size(900,900),
                            painter: canva))),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: ControllPanel(canva: canva,),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
