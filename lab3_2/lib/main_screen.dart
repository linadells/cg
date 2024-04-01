import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'canva.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'control_pannel.dart';
import 'styles.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});
  static bool type = false;
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late myCanva canva;

  var styleDrago = kButtonStyleActive, styleJulia = kButtonStyle;

  @override
  void initState() {
    super.initState();
    canva = myCanva();
  }

  Future<void> getImage(myCanva canva) async {
    final PictureRecorder recorder = PictureRecorder();
    canva.paint(Canvas(recorder), canva.mSize);
    final Picture picture = recorder.endRecording();

    ui.Image image = await picture.toImage(
        canva.mSize.width.toInt(), canva.mSize.height.toInt());
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final String filePath =
      path.join('D:/user/Downloads', 'canvas_image.png');

      final File file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      print("Image saved at: $filePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(
              flex: 10,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(2),
                child: SizedBox(
                  child: DefaultTextStyle(
                    child: AnimatedTextKit(
                      animatedTexts: [TypewriterAnimatedText('fractals')],
                    ),
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 40.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(3),
                child: TextButton(
                  style: styleJulia,
                  onPressed: () {
                    setState(() {
                      styleJulia = kButtonStyleActive;
                      styleDrago=kButtonStyle;
                      mainScreen.type = true;
                    });
                  },
                  child: Text(
                    'julia',
                    style: kTextStyle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(3),
                child: TextButton(
                  style: styleDrago,
                  onPressed: () {
                    setState(() {
                      styleJulia = kButtonStyle;
                      styleDrago=kButtonStyleActive;
                      mainScreen.type = false;
                    });
                  },
                  child: Text(
                    'drago',
                    style: kTextStyle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(3),
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    //canva.saveImage();
                    getImage(canva);
                  },
                  icon: Icon(
                    Icons.save_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Listener(
                    onPointerDown: (PointerDownEvent event){
                      setState(() {
                        canva.mouseX=event.localPosition.dx;
                        canva.mouseY=event.localPosition.dy;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: kFrame,
                      child: ClipRect(
                        child: CustomPaint(
                          size: Size(1000, 1000),
                          painter: canva,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: ControllPanel(
                      canva: canva,
                    ),
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
