// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'canva.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'control_pannel.dart';
// import 'styles.dart';
//
// class mainScreen extends StatefulWidget {
//   const mainScreen({super.key});
//
//   @override
//   State<mainScreen> createState() => _mainScreenState();
// }
// class _mainScreenState extends State<mainScreen> {
//   late myCanva canva;
//   //GlobalKey _repaintBoundaryKey = GlobalKey();
//
//
//   @override
//   void initState() {
//     super.initState();
//     canva = myCanva();
//   }
//
//   // Future<void> _save() async {
//   //   RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
//   //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//   //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//   //   Uint8List? pngBytes = byteData?.buffer.asUint8List();
//   //
//   //   final result = await ImageGallerySaver.saveImage(
//   //     Uint8List.fromList(pngBytes as List<int>),
//   //     quality: 60,
//   //     name: "canvas_image",
//   //   );
//   //   print(result);
//   // }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//               child: DefaultTextStyle(
//                 child: AnimatedTextKit(
//                   animatedTexts: [TypewriterAnimatedText('drago fractal')],
//                 ),
//                 style: TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: 40.0,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//               IconButton(
//                 style: kButtonStyle,
//                 onPressed: () {
//                   //_save();
//                 },
//                 icon: Icon(
//                   Icons.save_alt_outlined,
//                   color: Colors.white,
//                 ),
//               ),
//             ]
//           ),
//           Expanded(
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     margin: EdgeInsets.all(5),
//                     decoration: kFrame,
//                     child: RepaintBoundary(
//                       //key: _repaintBoundaryKey,
//                       child: ClipRect(
//                         child: CustomPaint(
//                           size: Size(900, 900),
//                           painter: canva,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     child: ControllPanel(
//                       canva: canva,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//



import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  // GlobalKey _repaintBoundaryKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    canva = myCanva();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: DefaultTextStyle(
                    child: AnimatedTextKit(
                      animatedTexts: [TypewriterAnimatedText('drago fractal')],
                    ),
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 40.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  style: kButtonStyle,
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.save_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ]
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
                    child: ClipRect(
                      child: CustomPaint(
                        size: Size(900, 900),
                        painter: canva,
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
