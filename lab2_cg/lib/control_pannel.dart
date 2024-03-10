import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lab2_cg/point.dart';
import 'coord_field.dart';
import 'styles.dart';
import 'canva.dart';


class ControllPanel extends StatefulWidget {
  myCanva canva;
  ControllPanel({required this.canva});
  int choosenPoint = 0;
  int quant = 2;
  CoordField t=CoordField(hintText: 'Enter t', controller: TextEditingController(),);
  CoordField q=CoordField(hintText: 'Enter quantity', controller: TextEditingController(),);
  CoordField i = CoordField(hintText: 'Enter i', controller: TextEditingController(),);
  List<CoordField> listOfFieldsX = [CoordField(hintText: '0X: 1.0', controller: TextEditingController(),),CoordField(hintText: '1X: 1.0', controller: TextEditingController(),)];
  List<CoordField> listOfFieldsY = [CoordField(hintText: '0Y: 1.0', controller: TextEditingController(),),CoordField(hintText: '1Y: 1.0', controller: TextEditingController(),)];

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
                    'Quantity: ${widget.quant}',
                    style: kSubtitle,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      if(widget.quant>2){
                        if(widget.choosenPoint==widget.quant-1){
                          widget.choosenPoint--;
                        }
                        widget.quant--;
                        widget.listOfFieldsX.removeLast();
                        widget.listOfFieldsY.removeLast();
                      }
                    });
                  },
                  icon: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Expanded(
                child: IconButton(
                  style: kButtonStyle,
                  onPressed: () {
                    setState(() {
                      widget.quant++;
                      widget.listOfFieldsX.add(CoordField(hintText: '${widget.quant-1}X: 1.0', controller: TextEditingController(),));
                      widget.listOfFieldsY.add(CoordField(hintText: '${widget.quant-1}Y: 1.0', controller: TextEditingController(),));
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      setState(() {
                        if(widget.choosenPoint+1<widget.quant){
                          setState(() {
                            widget.choosenPoint++;
                            widget.listOfFieldsX[widget.choosenPoint].controller = TextEditingController();
                            widget.listOfFieldsY[widget.choosenPoint].controller = TextEditingController();
                          });
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(widget.choosenPoint.toString()),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      if(widget.choosenPoint>0){
                        setState(() {
                          widget.choosenPoint--;
                          widget.listOfFieldsX[widget.choosenPoint].controller = TextEditingController();
                          widget.listOfFieldsY[widget.choosenPoint].controller = TextEditingController();
                        });
                      }
                    },
                  ),
                ],
              ),
              Expanded(child: widget.listOfFieldsX[widget.choosenPoint]),
              Expanded(child: widget.listOfFieldsY[widget.choosenPoint]),

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
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                    style: kButtonStyle,
                    onPressed: () {
                      setState(() {
                        widget.canva.step=widget.t.val;
                        if(widget.canva.drawBez){
                          widget.canva.points.clear();
                          widget.canva.pointsOfCurve.clear();
                          widget.canva.drawBez=false;
                        }
                        for(int i=0;i<widget.quant;i++){
                          widget.canva.points.add(Point(widget.listOfFieldsX[i].val, widget.listOfFieldsY[i].val));
                        }
                        widget.canva.drawBez=true;
                      });
                    },
                    child: Text(
                      'Recursive formula',
                      style: kTextStyle,
                    ),
                  ),
                      TextButton(
                        style: kButtonStyle,
                        onPressed: () {
                          widget.canva.step=widget.t.val;
                          setState(() {
                            if(widget.canva.drawPar){
                              widget.canva.points.clear();
                              widget.canva.pointsOfCurve.clear();
                              widget.canva.drawPar=false;
                            }
                            for(int i=0;i<widget.quant;i++){
                              widget.canva.points.add(Point(widget.listOfFieldsX[i].val, widget.listOfFieldsY[i].val));
                            }
                            widget.canva.step=widget.t.val;
                            widget.canva.drawPar=true;
                          });
                        },
                        child: Text(
                          'Parametric formula',
                          style: kTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: widget.t,
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
                child: Column(
                  children: [
                  widget.i,
                  TextButton(
                    style: kButtonStyle,
                    onPressed: () {
                      String text=widget.canva.getStringBernsteinCoefficient(widget.i.val.toInt(), widget.t.val);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Bernstein Coefficients:'),
                            content: Text(text),
                            actions: [
                              TextButton(
                                style: kButtonStyle,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close', style: kTextStyle,),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Get coefficients',
                      style: kTextStyle,
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,)
              ),
              SizedBox(width: 10,),
              Expanded(
                  child: Column(
                    children: [
                      widget.q,
                      TextButton(
                        style: kButtonStyle,
                        onPressed: () {
                          String text=widget.canva.getCoords(widget.q.val.toInt());
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Points of curve:'),
                                content: Text(text),
                                actions: [
                                  TextButton(
                                    style: kButtonStyle,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close', style: kTextStyle,),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Get coordinates',
                          style: kTextStyle,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,)
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}