import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Asia Robotica",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulBuilder {
  Inicio({super.key, required Key key }) : super (key key)

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("prueba"),
      ),
    )
  }
}
