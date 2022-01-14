import 'package:flutter/material.dart';
import 'package:flutter_drawing_screen/draw_screen_two.dart';
import 'package:flutter_drawing_screen/test_painter.dart';

import 'draw_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drawing Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              child: Card(
                margin: const EdgeInsets.only(top: 32, left: 90, right: 90),
                elevation: 7,
                shadowColor: Colors.green,
                child: InkWell(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const Draw()),),
                  child: Image.asset("assets/draw_screen.jpg", width: 150, height: 300,fit: BoxFit.fill,)),
              ),
            ),
            SizedBox(
              width: size.width,
              child: Card(
                margin: const EdgeInsets.only(top: 32, left: 90, right: 90),
                elevation: 7,
                shadowColor: Colors.red,
                child: InkWell(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const CanvasPainting()),),
                  child: Image.asset("assets/draw_screen_two.jpg", width: 150, height: 300,fit: BoxFit.fill,)),
              ),
            ),
            SizedBox(
              width: size.width,
              child: Card(
                elevation: 7,
                margin: const EdgeInsets.only(top: 32, bottom: 32, left: 90, right: 90),
                shadowColor: Colors.blue,
                child: InkWell(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const TestPainter()),),
                  child: Image.asset("assets/painting.jpg", width: 150, height: 300,fit: BoxFit.fill,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
