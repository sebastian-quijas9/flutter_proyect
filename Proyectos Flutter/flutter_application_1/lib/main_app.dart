// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Transform.scale(
              scale: 1.2,
              child: Image(
                image: NetworkImage('https://i.ibb.co/qY33LcH/descarga.jpg'),
                width: 1000,
              ),
            ),
            Positioned(
              bottom: -170.0,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Color.fromARGB(255, 229, 123, 115),
                backgroundImage: AssetImage("assets/img/person.png"),
              ),
            )
          ],
        ),
        SizedBox(height: 200),
        ListTile(
          title: Center(child: Text('Nombre:', style: TextStyle(fontSize: 30))),
          subtitle:
              Center(child: Text('Sebastian', style: TextStyle(fontSize: 25))),
        ),
        ListTile(
          title: Center(child: Text('', style: TextStyle(fontSize: 30))),
        ),
        ListTile(
          title: Center(
              child: Text('Apellido Paterno:', style: TextStyle(fontSize: 30))),
          subtitle:
              Center(child: Text('Garcia', style: TextStyle(fontSize: 25))),
        ),
        ListTile(
          title: Center(child: Text('', style: TextStyle(fontSize: 30))),
        ),
        ListTile(
          title: Center(
              child: Text('Apellido Materno:', style: TextStyle(fontSize: 30))),
          subtitle:
              Center(child: Text('Quijas', style: TextStyle(fontSize: 25))),
        ),
        ListTile(
          title: Center(child: Text('', style: TextStyle(fontSize: 30))),
        ),
        ListTile(
          title: Center(child: Text('Area:', style: TextStyle(fontSize: 30))),
          subtitle: Center(
              child: Text('Desarrollado Tecnologico',
                  style: TextStyle(fontSize: 20))),
        ),
      ],
    );
  }
}
