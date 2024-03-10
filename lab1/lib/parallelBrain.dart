import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab1/canva.dart';
import 'control_pannel.dart';
import 'point.dart';
import 'styles.dart';
import 'canva.dart';

class ParallelBrain {
  BuildContext context;
  myCanva canva;
  ParallelBrain({required this.context, required this.canva});

  bool ifThisIsIn2Q(List<Point> points){
    for(int i=0;i<points.length;i++){
      if(points[i].x>0 ||points[i].y<0){
        exceptionDialog('Incorrect input', 'It isn`t in second quarter');
        return false;
      }
    }
    return true;
  }

  void addPoints(int num, Color col1, Color col2) {
    List<Point> tempPoints = [];
    try {
      for (int i = 0; i < num; i++) {
        if (ControllPanel.coordFields4X[i].val != -999 &&
            ControllPanel.coordFields4Y[i].val != -999) {
          tempPoints.add(Point(ControllPanel.coordFields4X[i].val,
              ControllPanel.coordFields4Y[i].val));
        } else {
          throw Exception();
        }
      }
      if(num==3) tempPoints.add(findLastPoint(tempPoints));
      if(ifThisIsIn2Q(tempPoints)) {
        canva.allFigures.add(Shape(points: tempPoints,
            diag1: col1,
            diag2: col2,
            background: getRandomColor()));
        if(checkIfParall()!=true){
          canva.allFigures.removeLast();
        }
      }
    } catch (e) {
      exceptionDialog('Incorrect data', 'Not points are inputted');
    }
  }

  Point findLastPoint(List<Point> points){
    Point O=Point((points[0].x+points[2].x)/2, (points[0].y+points[2].y)/2);
    Point Last=Point(O.x*2-points[1].x, O.y*2-points[1].y);

    for(int i=0;i<3;i++){
      int m=i+2, i2=i+1;
      if(m>2) m-=2;
      if(i2>2) i2-=2;
      O=Point((points[i].x+points[m].x)/2, (points[i].y+points[m].y)/2);
      Last=Point(O.x*2-points[i2].x, O.y*2-points[i2].y);

      if(Last.x<=0 && Last.y>=0) break;
    }
    return Last;
  }

  double k(int coord1, int coord2) {
    if (canva.allFigures.last.points[coord1].x -
            canva.allFigures.last.points[coord2].x ==
        0) return 0;
    double b = (canva.allFigures.last.points[coord1].y -
            canva.allFigures.last.points[coord2].y) /
        (canva.allFigures.last.points[coord1].x -
            canva.allFigures.last.points[coord2].x);
    print('k $coord1 $coord2: $b');
    return b;
  }

  double b(int coord1, int coord2) {
    if (canva.allFigures.last.points[coord2].x -
            canva.allFigures.last.points[coord1].x ==
        0) return canva.allFigures.last.points[coord1].y;
    double n = -((canva.allFigures.last.points[coord2].y -
                canva.allFigures.last.points[coord1].y) *
            canva.allFigures.last.points[coord1].x /
            (canva.allFigures.last.points[coord2].x -
                canva.allFigures.last.points[coord1].x)) +
        canva.allFigures.last.points[coord1].y;
    print('b $coord1 $coord2: $n');
    return n;
  }

  bool checkIfParall() {
    try {
      if (k(1, 0) == k(3, 2) &&
          k(3, 0) == k(1, 2) &&
          b(1, 0) != b(2, 3) &&
          b(3, 0) != b(1, 2)) {
        canva.drawPar = true;
      } else if (k(2, 0) == k(3, 1) &&
          k(3, 0) == k(2, 1) &&
          b(2, 0) != b(3, 1) &&
          b(3, 0) != b(2, 1)) {
        canva.allFigures.last.points = [
          canva.allFigures.last.points[0],
          canva.allFigures.last.points[2],
          canva.allFigures.last.points[1],
          canva.allFigures.last.points[3]
        ];
        canva.drawPar = true;
      } else {
        throw Exception();
      }
    } catch (e) {
      exceptionDialog('Incorrect data',
          'Input correct points. Fields are empty or this figure isn`t parallelogram');
      return false;
    }
    return true;
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // червоний
      random.nextInt(256), // зелений
      random.nextInt(256), // синій
      1.0, // прозорість
    );
  }

  void exceptionDialog(String title, String text) {
    showDialog(
      context: context, // Use the member variable
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: kButtonText,
              ),
            ),
          ],
        );
      },
    );
  }
}
