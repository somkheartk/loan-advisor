import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

void main() async {
  // สร้าง icon
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = Size(512, 512);

  // Background
  final paint = Paint()..color = Color(0xFF4285F4);
  canvas.drawCircle(Offset(256, 256), 240, paint);

  // Calculator icon
  final whitePaint = Paint()..color = Colors.white;
  canvas.drawRRect(
      RRect.fromLTRBR(156, 120, 356, 380, Radius.circular(20)), whitePaint);

  // Display area
  final grayPaint = Paint()..color = Color(0xFFF0F0F0);
  canvas.drawRRect(
      RRect.fromLTRBR(170, 140, 342, 200, Radius.circular(8)), grayPaint);

  // Text
  final textPainter = TextPainter(
    text: TextSpan(
      text: '\$125,500',
      style: TextStyle(
        color: Color(0xFF4285F4),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(256 - textPainter.width / 2, 165));

  // Dollar sign overlay
  final greenPaint = Paint()..color = Color(0xFF34A853);
  canvas.drawCircle(Offset(370, 160), 35, greenPaint);

  final dollarPainter = TextPainter(
    text: TextSpan(
      text: '\$',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  dollarPainter.layout();
  dollarPainter.paint(canvas, Offset(370 - dollarPainter.width / 2, 140));

  // App name
  final appNamePainter = TextPainter(
    text: TextSpan(
      text: 'LOAN\nADVISOR',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );
  appNamePainter.layout();
  appNamePainter.paint(canvas, Offset(256 - appNamePainter.width / 2, 410));

  final picture = recorder.endRecording();
  final img = await picture.toImage(512, 512);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  await File('assets/images/app_icon_512.png').writeAsBytes(buffer);
  print('Icon created successfully!');
}
