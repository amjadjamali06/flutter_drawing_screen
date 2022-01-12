import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints?> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  bool isFirstTap=true;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.strokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.greenAccent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.album),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.strokeWidth) {
                                showBottomList = !showBottomList;
                              }
                              selectedMode = SelectedMode.strokeWidth;
                            });
                          }),
                      IconButton(
                          icon: const Icon(Icons.opacity),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.opacity) {
                                showBottomList = !showBottomList;
                              }
                              selectedMode = SelectedMode.opacity;
                            });
                          }),
                      IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: () {
                            setState(() {
                              if (selectedMode == SelectedMode.color) {
                                showBottomList = !showBottomList;
                              }
                              selectedMode = SelectedMode.color;
                            });
                          }),
                      IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () {
                            _save(context).then((result) => log('=========SaveResult> $result'));
                          }),
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              showBottomList = false;
                              points.clear();
                            });
                          }),
                    ],
                  ),
                  Visibility(
                    child: (selectedMode == SelectedMode.color)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getColorList(),
                          )
                        : Slider(
                            value: (selectedMode == SelectedMode.strokeWidth)
                                ? strokeWidth
                                : opacity,
                            max: (selectedMode == SelectedMode.strokeWidth)
                                ? 50.0
                                : 1.0,
                            min: 0.0,
                            onChanged: (val) {
                              setState(() {
                                if (selectedMode == SelectedMode.strokeWidth) {
                                  strokeWidth = val;
                                } else {
                                  opacity = val;
                                }
                              });
                            }),
                    visible: showBottomList,
                  ),
                ],
              ),
            )),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            log('======onPanUpdate>');
              // RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(DrawingPoints(
                  points: /*renderBox.globalToLocal(*/details.globalPosition/*)*/,
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));

          });
        },
        onPanStart: (details) {
          setState(() {
            // RenderBox renderBox = context.findRenderObject() as RenderBox;
            log('======onPanStart>');
            // isFirstTap=true;
            // log('======G> ${details.globalPosition}');
            // log('======GTL> ${renderBox.globalToLocal(details.localPosition)}');
            // log('======LTG> ${renderBox.localToGlobal(details.globalPosition)}');
            // points.add(DrawingPoints(
            //     points: renderBox.globalToLocal(details.localPosition),
            //     paint: Paint()
            //       ..strokeCap = strokeCap
            //       ..isAntiAlias = true
            //       ..color = selectedColor.withOpacity(opacity)
            //       ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(
            pointsList: points,
          ),
        ),
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = [];
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  showLabel: true,
                  // labelTypes: const [ColorLabelType.hex],
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() => selectedColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
        },
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }

  Future<String> _save(BuildContext context) async {
    RenderRepaintBoundary? boundary = context.findAncestorRenderObjectOfType<RenderRepaintBoundary>();
    if(boundary==null){
      return "Render Repaint Boundary not Found!";
    }
    ui.Image image = await boundary.toImage();
    ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))??ByteData(0);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    //Request permissions if not already granted
    // if (!(await Permission.storage.status.isGranted))
    //   await Permission.storage.request();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: "canvas_image");
    return (result!=null && result["isSuccess"]) ? "Success"
        : (result!=null) ? result["errorMessage"]??"":"";
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});
  List<DrawingPoints?> pointsList;
  List<Offset> offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i]!.points, pointsList[i + 1]!.points,
            pointsList[i]!.paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i]!.points);
        offsetPoints.add(Offset(
            pointsList[i]!.points.dx + 0.1, pointsList[i]!.points.dy + 0.1));
        canvas.drawPoints(ui.PointMode.points, offsetPoints, pointsList[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({required this.points, required this.paint});
}

enum SelectedMode { strokeWidth, opacity, color }
