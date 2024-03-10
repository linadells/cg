import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lab2_cg/point.dart';

class myCanva extends CustomPainter {
  Color paral = Colors.black, plane = Colors.grey;
  List<Point> points=[];
  List<Offset> controlPoints=[];
  List<Offset> pointsOfCurve=[];
  late Canvas mCanvas;
  late Size mSize;
  bool drawBez = false;
  bool drawPar=false;
  double step=0.1;
  double i=1;
  double widthOfCell = 1;
  double heightOfCell = 1;

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
    if(drawBez){
      controlPoints=convertPoints(points);
      drawBezier(controlPoints);
    }
    if(drawPar){
      controlPoints=convertPoints(points);
      drawControlPoints(controlPoints);
      pointsOfCurve=convertPoints(computeBezierCurvePoints(points, step));
      drawCurvePoints(pointsOfCurve);
    }

  }

  Point convertPointsBack(Offset point){
    return Point((point.dx -mSize.width/2)/widthOfCell,
        (point.dy -mSize.height/2)/heightOfCell);
  }

  List<Offset> convertPoints(List<Point> list){
    List<Offset> res=[];
    for(int i=0;i<list.length;i++){
      res.add(Offset(mSize.width / 2 + list[i].x *
          widthOfCell,
          mSize.height / 2 - list[i].y * heightOfCell));
    }
    return res;
  }

  void drawControlPoints(List<Offset> points){
    Paint paint = Paint()
      ..color = Color(0xFF303F9F)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    mCanvas.drawLine(points.first, points.first, paint);
    mCanvas.drawLine(points.last, points.last, paint);

    paint = Paint()
      ..color = Colors.amberAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for(int i=1;i<points.length-1;i++){
      mCanvas.drawLine(points[i], points[i], paint);
    }
  }

  void drawCurvePoints(List<Offset> points){
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.5;

    for(int i=0;i<pointsOfCurve.length;i++){
      mCanvas.drawLine(pointsOfCurve[i], pointsOfCurve[i], paint);
    }
  }

  void drawBezier(List<Offset> points) {
    if (points.length < 2) {
      return;
    }
    for(double i=0;i<1;i+=step){
      Offset t=recursiveBezier(points, i);
      pointsOfCurve.add(t);
    }

    drawControlPoints(points);
    drawCurvePoints(points);
  }


  Offset recursiveBezier(List<Offset> points, double t){
    if(points.length==1){
      return points[0];
    }
    List<Offset> nextPoints = [];

    for (int i = 0; i < points.length - 1; i++) {
      Offset pointOnCurve = points[i] * (1 - t) + points[i + 1] * t;
      nextPoints.add(pointOnCurve);
    }
    return recursiveBezier(nextPoints, t);
  }

  List<Point> computeBezierCurvePoints(List<Point> controlPoints, double step) {
    if (controlPoints.length < 2) {
      throw ArgumentError('At least two control points are required.');
    }

    List<Point> curvePoints = [];

    for (double t = 0.0; t <= 1.0; t += step) {
      Point point = computeBezierPoint(t, controlPoints);
      curvePoints.add(point);
    }

    return curvePoints;
  }

  static Point computeBezierPoint(double t, List<Point> controlPoints) {
    int n = controlPoints.length - 1;
    double x = 0.0;
    double y = 0.0;

    for (int i = 0; i <= n; i++) {
      double coefficient = bernsteinCoefficient(n, i, t);
      x += coefficient * controlPoints[i].x;
      y += coefficient * controlPoints[i].y;
    }

    return Point(x, y);
  }

  static double bernsteinCoefficient(int n, int i, double t) {
    return binomialCoefficient(n, i).toDouble() * pow(1 - t, n - i) * pow(t, i);
  }

  static int binomialCoefficient(int n, int k) {
    if (k < 0 || k > n) {
      return 0;
    }

    if (k == 0 || k == n) {
      return 1;
    }

    return factorial(n) ~/ (factorial(k) * factorial(n - k));
  }

  static int factorial(int n) {
    if (n == 0 || n == 1) {
      return 1;
    }

    return n * factorial(n - 1);
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

  String getStringBernsteinCoefficient(int i, double t){
    String res='';
    if(i>points.length-1) return 'Invalid i';
    for(int i=0;i<points.length;i++){
      res+=bernsteinCoefficient(points.length-1, i, t).toString();
      res+='; ';
    }
    return res;
  }

  String getCoords(int q){
    String res='';
    if(q>pointsOfCurve.length-1) return 'Invalid quantity';
    int s=(pointsOfCurve.length/q).toInt();
    for(int i=0;i<pointsOfCurve.length;i+=s){
      res+=convertPointsBack(pointsOfCurve[i]).toString();
    }
    return res;
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
    return false;
  }

}
