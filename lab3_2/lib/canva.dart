import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lab3_2/main_screen.dart';

enum Direction { Left, Right }

class myCanva extends CustomPainter {
  Color startColor = Colors.black, plane = Colors.grey;
  late Canvas mCanvas;
  late Size mSize;
  double widthOfCell = 1;
  double heightOfCell = 1;
  int depth = 0;
  double lenght = 10, x = -5, y = 0, angle = 0;
  late double rX, rY;
  double coord=2;
  double mouseX=0, mouseY=0;
  double ca = - 0.70176, cb = - 0.3842;
  double resol=10;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = startColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    this.mCanvas = canvas;
    this.mSize = size;
    widthOfCell = mSize.width / 20;
    heightOfCell = mSize.height / 20;

    rX = size.width / 2 + x * widthOfCell;
    rY = size.height / 2 - y * heightOfCell;

    if(!mainScreen.type){
      drawDragonTriangle(canvas, paint, depth, Direction.Right, rX, rY,
          lenght * widthOfCell, angle, startColor);
    }else{
      drawJuliaFractal(canvas, mSize);
    }

  }

  Future<void> drawDragonTriangle(
      Canvas canvas,
      Paint paint,
      int level,
      Direction turnTowards,
      double x1,
      double y1,
      double dx,
      double dy,
      Color startColor) async {
    if (level <= 0) {
      Path path = Path();
      path.moveTo(x1, y1);
      path.lineTo(x1 + dx, y1 + dy);
      double nx = dx / 2;
      double ny = dy / 2;
      double dx2 = -ny + nx;
      double dy2 = nx + ny;
      double x2, y2;

      if (turnTowards == Direction.Right) {
        x2 = x1 + dx2;
        y2 = y1 + dy2;
      } else {
        x2 = x1 + dy2;
        y2 = y1 - dx2;
      }
      path.lineTo(x2, y2);
      path.close();
      paint.color = startColor;

      canvas.drawPath(path, paint);
    } else {
      double nx = dx / 2;
      double ny = dy / 2;
      double dx2 = -ny + nx;
      double dy2 = nx + ny;
      double x2, y2;

      List<Future<void>> futures = [];

      if (turnTowards == Direction.Right) {
        futures.add(drawDragonTriangle(canvas, paint, level - 1, Direction.Right, x1, y1,
            dx2, dy2, startColor.withOpacity(0.1)));
        x2 = x1 + dx2;
        y2 = y1 + dy2;
        futures.add(drawDragonTriangle(canvas, paint, level - 1, Direction.Left, x2, y2,
            dy2, -dx2, startColor.withOpacity(0.3)));
      } else {
        futures.add(drawDragonTriangle(canvas, paint, level - 1, Direction.Right, x1, y1,
            dy2, -dx2, startColor.withOpacity(0.6)));
        x2 = x1 + dy2;
        y2 = y1 - dx2;
        futures.add(drawDragonTriangle(canvas, paint, level - 1, Direction.Left, x2, y2,
            dx2, dy2, startColor.withOpacity(0.9)));
      }

      await Future.wait(futures);
    }
  }

  double map(double value, double min1, double max1, double min2, double max2) {
    return min2 + ((value - min1) / (max1 - min1)) * (max2 - min2);
  }


  void drawJuliaFractal(Canvas canvas, Size size) {
    final int maxIterations = 100;
    final double startX = 0;
    final double endX = size.width;
    final double startY = 0;
    final double endY = size.height;

    final int chunkSize = 50;

    Future<void> parallelExecution() async {
      List<Future> futures = [];

      if(mouseY!=0 || mouseX!=0){
        ca=map(mouseX, 0, size.width, -1, 1);
        cb=map(mouseY, 0, size.height, -1, 1);
      }

      for (double x = startX; x < endX; x += chunkSize) {
        for (double y = startY; y < endY; y += chunkSize) {
          futures.add(_computeChunk(x, y, chunkSize, maxIterations, canvas, size));
        }
      }

      await Future.wait(futures);
      print('end of painting with resol: $resol ca:$ca, cb: $cb');
    }

    parallelExecution();
  }

  Future<void> _computeChunk(double startX, double startY, int chunkSize, int maxIterations, Canvas canvas, Size size) async {
    for (double x = startX; x < startX + chunkSize; x+=resol) {
      for (double y = startY; y < startY + chunkSize; y+=resol) {
        double a = map(x.toDouble(), 0, size.width.toDouble(), -coord, coord);
        double b = map(y.toDouble(), 0, size.height.toDouble(), -coord, coord);


        int n = 0;
        while (n < maxIterations) {
          double aa = a * a;
          double bb = b*b;
          double ab2=2*a*b;

          a = aa - bb + ca;
          b = ab2 + cb;

          if (aa*aa+bb*bb > 100) {
            break;
          }
          n++;
        }

        double col = map(n.toDouble(), 0, maxIterations.toDouble(), 0, 255);
        if (n == maxIterations) col = 0;

        Paint paint = Paint()..color = generateColorShade(startColor, col.toInt());
        Rect rect=Rect.fromLTWH(x+resol, y+resol, x, y);
        canvas.drawRect(rect, paint);
      }
    }
  }

  Color generateColorShade(Color baseColor, int intensity) {
    // Отримуємо значення каналів RGB базового кольору
    int red = baseColor.red;
    int green = baseColor.green;
    int blue = baseColor.blue;

    red = (red + intensity).clamp(
        0, 255); // Обмежуємо значення до діапазону [0, 255]
    green = (green + 3*intensity).clamp(0, 255);
    blue = (blue + 2*intensity).clamp(0, 255);

    // Повертаємо новий колір
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
