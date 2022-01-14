import 'package:flutter/material.dart';
import 'package:flutter_drawing_screen/draw_screen_two.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drawing Demo"),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const CanvasPainting()),))],
      ),
      body: const Center(
        child: Text(
          'Click Edit Button start Drawing...',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Draw())),
        tooltip: 'Increment',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
