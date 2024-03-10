import 'package:flutter/material.dart';
import 'coord_field.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'styles.dart';
import 'canva.dart';
import 'parallelBrain.dart';

class ControllPanel extends StatefulWidget {
   myCanva canva;
  ControllPanel({required this.canva});
  static late List<CoordField> coordFields4X = [
    CoordField(hintText: '1 point: X'),
    CoordField(hintText: '2 point: X'),
    CoordField(hintText: '3 point: X'),
    CoordField(hintText: '4 point: X'),
  ];
  static late List<CoordField> coordFields4Y = [
    CoordField(hintText: '1 point: Y'),
    CoordField(hintText: '2 point: Y'),
    CoordField(hintText: '3 point: Y'),
    CoordField(hintText: '4 point: Y')
  ];

  @override
  State<ControllPanel> createState() => _ControllPanelState();
}

class _ControllPanelState extends State<ControllPanel> {
  late ParallelBrain brain;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  Color currentColor2 = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
    brain=ParallelBrain(context: context, canva: widget.canva);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: kFrame,
            child: Column(
              children: [
                Text(
                  'Enter 4 coordinates:',
                  style: kSubtitle,
                ),
                Expanded(
                  child: Row(children: [
                    Expanded(
                      child: ControllPanel.coordFields4X[0],
                    ),
                    Expanded(
                      child: ControllPanel.coordFields4Y[0],
                    )
                  ]),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: ControllPanel.coordFields4X[1]),
                      Expanded(child: ControllPanel.coordFields4Y[1]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: ControllPanel.coordFields4X[2]),
                      Expanded(
                          child: ControllPanel.coordFields4Y[2]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: ControllPanel.coordFields4X[3]),
                      Expanded(
                          child: ControllPanel.coordFields4Y[3]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: TextButton(
                      style: kButtonStyle,
                      onPressed: () {
                        setState(() {
                          brain.addPoints(4, currentColor, currentColor2);
                        });
                      },
                      child: Text(
                        'Check and draw',
                        style: kTextStyle,
                      )),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: kFrame,
            child: Column(
              children: [
                Text(
                  'Enter 3 coordinates:',
                  style: kSubtitle,
                ),
                Expanded(
                  child: Row(children: [
                    Expanded(
                      child: ControllPanel.coordFields4X[0],
                    ),
                    Expanded(
                      child: ControllPanel.coordFields4Y[0],
                    )
                  ]),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: ControllPanel.coordFields4X[1]),
                      Expanded(child: ControllPanel.coordFields4Y[1]),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: ControllPanel.coordFields4X[2]),
                      Expanded(child: ControllPanel.coordFields4Y[2]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: TextButton(
                      style: kButtonStyle,
                      onPressed: () {
                        brain.addPoints(3, currentColor, currentColor2);
                      },
                      child: Text(
                        'Calculate and draw',
                        style: kTextStyle,
                      )),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: kFrame,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Color of 1 diagonal',
                        style: kSubtitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: kButtonStyle,
                              child: Text(
                                'Choose color',
                                style: kTextStyle,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Pick a color!',
                                        style: kSubtitle,
                                      ),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: (value) {
                                            pickerColor = value;
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text(
                                            'Got it',
                                            style: TextStyle(
                                                color: Color(0xFF303F9F)),
                                          ),
                                          onPressed: () {
                                            setState(() =>
                                                currentColor = pickerColor);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.all(5),
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Color of 2 diagonal',
                        style: kSubtitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: kButtonStyle,
                              child: Text(
                                'Choose color',
                                style: kTextStyle,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Pick a color!',
                                        style: kSubtitle,
                                      ),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: (value) {
                                            pickerColor = value;
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text(
                                            'Got it',
                                            style: kButtonText),
                                          onPressed: () {
                                            setState(() =>
                                                currentColor2 = pickerColor);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.all(5),
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentColor2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
