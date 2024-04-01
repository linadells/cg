import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

enum Direction { Left, Right }

class myCanva extends CustomPainter {
  //GlobalKey globalKey;

  //myCanva(this.globalKey);
  Color startColor = Colors.black, plane=Colors.grey;
  late Canvas mCanvas;
  late Size mSize;
  double widthOfCell = 1;
  double heightOfCell = 1;
  int depth=0;
  double lenght=10, x=0, y=0, angle=0;
  late double rX, rY;

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

    rX=size.width/2+x*widthOfCell;
    rY=size.height/2-y*heightOfCell;

     drawDragonTriangle(canvas, paint, depth, Direction.Right,
         rX, rY, lenght*widthOfCell, angle, startColor);
  }
  void drawDragonTriangle(Canvas canvas, Paint paint, int level, Direction turnTowards, double x1, double y1, double dx, double dy, Color startColor) {
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

      if (turnTowards == Direction.Right) {
        drawDragonTriangle(canvas, paint, level - 1, Direction.Right, x1, y1, dx2, dy2, startColor.withOpacity(0.1));
        x2 = x1 + dx2;
        y2 = y1 + dy2;
        drawDragonTriangle(canvas, paint, level - 1, Direction.Left, x2, y2, dy2, -dx2, startColor.withOpacity(0.3));
      } else {
        drawDragonTriangle(canvas, paint, level - 1, Direction.Right, x1, y1, dy2, -dx2, startColor.withOpacity(0.6));
        x2 = x1 + dy2;
        y2 = y1 - dx2;
        drawDragonTriangle(canvas, paint, level - 1, Direction.Left, x2, y2, dx2, dy2, startColor.withOpacity(0.9));
      }
    }
  }


  // void saveCanvasImage() async {
  //   if (globalKey != null) {
  //     RenderRepaintBoundary boundary =
  //     globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     ui.Image image = await boundary.toImage();
  //     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //
  //     final result = await ImageGallerySaver.saveImage(pngBytes);
  //     if (result['isSuccess']) {
  //       print('Image saved successfully');
  //     } else {
  //       print('Failed to save image: ${result['error']}');
  //     }
  //   } else {
  //     print('Error: GlobalKey is null');
  //   }
  // }


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
      ..color = startColor
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
