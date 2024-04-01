import 'package:flutter/material.dart';
import 'package:lab3_2/main_screen.dart';
import 'coord_field.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'styles.dart';
import 'canva.dart';

class ControllPanel extends StatefulWidget {
  myCanva canva;
  ControllPanel({required this.canva});

  @override
  State<ControllPanel> createState() => _ControllPanelState();
}

class _ControllPanelState extends State<ControllPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: kFrame,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    mainScreen.type?'Resolution: ${1/widget.canva.resol}':
                    'Depth: ${widget.canva.depth}',
                    style: kSubtitle,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      if(mainScreen.type){
                        widget.canva.resol++;
                      }
                      else if (!mainScreen.type && widget.canva.depth > 0) {
                        widget.canva.depth--;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      if(mainScreen.type&& widget.canva.resol>1){
                        widget.canva.resol--;
                      }
                      else if (!mainScreen.type) {
                        widget.canva.depth++;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: kFrame,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    mainScreen.type?'Size: ${widget.canva.coord}':
                    'Lenght: ${widget.canva.lenght}',
                    style: kSubtitle,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      if (!mainScreen.type && widget.canva.lenght > 1) {
                        widget.canva.lenght --;
                      }
                      else if(mainScreen.type && widget.canva.coord > 0){
                        widget.canva.coord*=1.5;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      if (!mainScreen.type) {
                        widget.canva.lenght ++;
                      }
                      else if(mainScreen.type){
                        widget.canva.coord/=1.5;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      if(!mainScreen.type)
        Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: kFrame,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    'Angle:',
                    style: kSubtitle,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      widget.canva.angle-=10;
                    });
                  },
                  icon: Icon(
                    Icons.subdirectory_arrow_left_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      widget.canva.angle+=10;
                    });
                  },
                  icon: Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: kFrame,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    mainScreen.type?'Constant:':
                    'Start:',
                    style: kSubtitle,
                  ),
                ),
              ),
              Expanded(
                  child: CoordField(
                hintText:  mainScreen.type?'Enter a:':
                'Enter x',
                onChanged: (val) {
                  setState(() {
                    if(mainScreen.type){
                      widget.canva.ca=val;
                    }
                    else{
                      widget.canva.x = val;
                    }
                  });
                },
              )),
              Expanded(
                  child: CoordField(
                hintText: mainScreen.type?'Enter b:':
                'Enter y',
                onChanged: (val) {
                  setState(() {
                    if(mainScreen.type){
                      widget.canva.cb=val;
                    }
                    else{
                      widget.canva.y = val;
                    }
                  });
                },
              )),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: kFrame,
          child: Row(
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
                              pickerColor: widget.canva.startColor,
                              onColorChanged: (value) {
                                setState(() {
                                  widget.canva.startColor = value;
                                });
                              },
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text(
                                'Got it',
                                style: TextStyle(
                                  color: Color(0xFF303F9F),
                                ),
                              ),
                              onPressed: () {
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
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.canva.startColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
