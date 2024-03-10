import 'package:flutter/material.dart';
import 'point.dart';
import 'control_pannel.dart';
import 'point.dart';
import 'dart:math';

class myCanva extends CustomPainter {
  Color paral = Colors.black, plane = Colors.grey;
  late Canvas mCanvas;
  late Size mSize;
  bool drawPar = false;
  double widthOfCell = 1;
  double heightOfCell = 1;
  List<Shape> allFigures = [];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = plane
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    this.mCanvas = canvas;
    this.mSize = size;
    widthOfCell = mSize.width / 20;
    heightOfCell = mSize.height / 20;

    paintCoordinatePlane();
    if (drawPar) {
      for (int i = 0; i < allFigures.length; i++) {
        allFigures[i].draw(mCanvas, mSize, widthOfCell, heightOfCell);
      }
    }
  }

  void drawText(Color color, String text, double x, double y) {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 12.0,
      ),
    );

    textPainter.layout();
    textPainter.paint(
        mCanvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  void paintCoordinatePlane() {
    final Paint paint = Paint()
      ..color = plane
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    final double arrowLength = 20.0;
    final double arrowWidth = 10.0;

    mCanvas.drawLine(Offset(0.0, mSize.height / 2),
        Offset(mSize.width, mSize.height / 2), paint);
    mCanvas.drawLine(Offset(mSize.width / 2, 0),
        Offset(mSize.width / 2, mSize.height), paint);

    // Draw arrowhead at the end of x-axis
    Path arrowPath = Path();
    arrowPath.moveTo(
        mSize.width - arrowLength, mSize.height / 2 - arrowWidth / 2);
    arrowPath.lineTo(mSize.width, mSize.height / 2);
    arrowPath.lineTo(
        mSize.width - arrowLength, mSize.height / 2 + arrowWidth / 2);
    mCanvas.drawPath(arrowPath, paint);

    // Draw arrowhead at the end of y-axis
    arrowPath.moveTo(mSize.width / 2 - arrowWidth / 2, arrowLength);
    arrowPath.lineTo(mSize.width / 2, 0.0);
    arrowPath.lineTo(mSize.width / 2 + arrowWidth / 2, arrowLength);
    mCanvas.drawPath(arrowPath, paint);

    for (int i = 1; i < 20; i++) {
      mCanvas.drawLine(Offset(i * widthOfCell, (mSize.height + arrowWidth) / 2),
          Offset(i * widthOfCell, (mSize.height - arrowWidth) / 2), paint);
      mCanvas.drawLine(Offset((mSize.width - arrowWidth) / 2, i * heightOfCell),
          Offset((mSize.width + arrowWidth) / 2, i * heightOfCell), paint);
      if (i != 10) {
        drawText(
            plane, (i - 10).toString(), i * widthOfCell, mSize.height / 2 + 15);
        drawText(plane, (-i + 10).toString(), mSize.width / 2 + 15,
            i * heightOfCell - 2);
      }
    }
    drawText(plane, '0', mSize.width / 2 + 15, mSize.height / 2 + 15);
    drawText(plane, 'Ox', mSize.width-15, mSize.height/2+15);
    drawText(plane, 'Oy', mSize.width/2+15, 10);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Shape {
  Color diag1, diag2, background;
  List<Point> points = [];
  Shape({required this.points, required this.diag1, required this.diag2, required this.background});

  double findLenght(int p1, int p2) {
    double n = sqrt(pow(points[p2].x - points[p1].x, 2) +
        pow(points[p2].y - points[p1].y, 2));
    //print('lenght of $p1 $p2 $n');
    return n;
  }

  bool findCos(int p1, int m, int p2) {
    double a = findLenght(p1, m), b = findLenght(m, p2), c = findLenght(p1, p2);
    double x = (a * a + b * b - c * c) / (2 * a * b);
    return x > 0 ? false : true;
  }

  int findStupidAngle() {
    if (findCos(0, 1, 2)) return 1;
    return 0;
  }

  Point findHeight() {
    int p1 = findStupidAngle();
    double k=findK(p1+1, p1+2), b=findB(p1+1, p1+2);
    double x=(-b*k+points[p1].x+points[p1].y*k)/(1+k*k);
    Point p2=Point(x, k*x+b);
    return p2;
  }

  double findK(int coord1, int coord2) {
    if (points[coord1].x - points[coord2].x == 0) return 0;
    double b = (points[coord1].y - points[coord2].y) /
        (points[coord1].x - points[coord2].x);
    return b;
  }

  double findB(int coord1, int coord2) {
    if (points[coord2].x - points[coord1].x == 0) return points[coord1].y;
    double n = -((points[coord2].y - points[coord1].y) *
            points[coord1].x /
            (points[coord2].x - points[coord1].x)) +
        points[coord1].y;
   // print('$coord1 $coord2: n');
    return n;
  }

  void draw(
      Canvas mCanva, Size mSize, double widthOfCell, double heightOfCell) {
    //drawPar=true;
    Paint paint = Paint()
      ..color = background
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    // Координати чотирьох точок чотирикутника
    Offset point1 = Offset(mSize.width / 2 + points[0].x * widthOfCell,
        mSize.height / 2 - points[0].y * heightOfCell);
    Offset point2 = Offset(mSize.width / 2 + points[1].x * widthOfCell,
        mSize.height / 2 - points[1].y * heightOfCell);
    Offset point3 = Offset(mSize.width / 2 + points[2].x * widthOfCell,
        mSize.height / 2 - points[2].y * heightOfCell);
    Offset point4 = Offset(mSize.width / 2 + points[3].x * widthOfCell,
        mSize.height / 2 - points[3].y * heightOfCell);

    // Малюємо заливкований прямокутник
    Path path = Path()
      ..moveTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy)
      ..lineTo(point3.dx, point3.dy)
      ..lineTo(point4.dx, point4.dy)
      ..close(); // З'єднуємо останню точку з першою

    mCanva.drawPath(path, paint);

    paint=Paint()
      ..color = Colors.black;

    //паралелограм
    for (int i = 0; i < points.length; i++) {
      int i2 = i + 1;
      if (i2 > 3) i2 = 0;

      mCanva.drawLine(
          Offset(mSize.width / 2 + points[i].x * widthOfCell,
              mSize.height / 2 - points[i].y * heightOfCell),
          Offset(mSize.width / 2 + points[i2].x * widthOfCell,
              mSize.height / 2 - points[i2].y * heightOfCell),
          paint);
    }


    //висоти і продовдення висоти
    Point p1=points[findStupidAngle()], p2=findHeight(), p3=points[findStupidAngle()+2], p4;
    if(findStupidAngle()+2==4) p4=points[0];
    else p4=points[3];
    mCanva.drawLine(
        Offset(mSize.width / 2 + p1.x * widthOfCell,
            mSize.height / 2 - p1.y * heightOfCell),
        Offset(mSize.width / 2 + p2.x * widthOfCell,
            mSize.height / 2 - p2.y * heightOfCell),
        paint);




    mCanva.drawLine(
        Offset(mSize.width / 2 + p3.x * widthOfCell,
            mSize.height / 2 - p3.y * heightOfCell),
        Offset(mSize.width / 2 + p2.x * widthOfCell,
            mSize.height / 2 - p2.y * heightOfCell),
        paint);


    //діагоналі
    paint = Paint()..color = diag1;
    mCanva.drawLine(
        Offset(mSize.width / 2 + points[0].x * widthOfCell,
            mSize.height / 2 - points[0].y * heightOfCell),
        Offset(mSize.width / 2 + points[2].x * widthOfCell,
            mSize.height / 2 - points[2].y * heightOfCell),
        paint);

    paint = Paint()..color = diag2;
    mCanva.drawLine(
        Offset(mSize.width / 2 + points[1].x * widthOfCell,
            mSize.height / 2 - points[1].y * heightOfCell),
        Offset(mSize.width / 2 + points[3].x * widthOfCell,
            mSize.height / 2 - points[3].y * heightOfCell),
        paint);

  }
}