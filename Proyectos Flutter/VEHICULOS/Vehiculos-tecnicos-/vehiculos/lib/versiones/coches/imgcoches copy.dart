// Funcional el puro coche con su imagen


import 'package:flutter/material.dart';

class VentanaEmergente extends StatelessWidget {
  final String imagenUrl;

  const VentanaEmergente({super.key, required this.imagenUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Mostrar la imagen aquí
            Image.network(imagenUrl),
            // Aquí puedes agregar lógica para el círculo o cualquier otra forma
            // También puedes agregar la opción de marcar con una palomita y el botón "Listo"
          ],
        ),
      ),
    );
  }
}

class ImgVehiculos extends StatefulWidget {
  const ImgVehiculos({Key? key}) : super(key: key);

  @override
  _ImgVehiculosState createState() => _ImgVehiculosState();
}

class _ImgVehiculosState extends State<ImgVehiculos> {
  // URLs de las imágenes para las cartas
  List<String> cartas = ['https://thumbs.dreamstime.com/z/resuma-el-dibujo-del-vector-del-coche-del-sed%C3%A1n-en-diverso-punto-de-vista-88887325.jpg', 'https://thumbs.dreamstime.com/z/resuma-el-dibujo-del-vector-del-coche-del-sed%C3%A1n-en-diverso-punto-de-vista-88887325.jpg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 23, 24, 0.8),
        title: const Text('IMG-Coches'),
        actions: <Widget>[
          // Botón "Listo"
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Lógica para aplicar cambios y actualizar la imagen en la carta
              // ...
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // Cartas
              GestureDetector(
                onTap: () {
                  // Al hacer clic en la primera carta, abrir la ventana emergente
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VentanaEmergente(imagenUrl: cartas[0])),
                  );
                },
                child: Card(
                  child: Image.network(cartas[0]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Al hacer clic en la segunda carta, abrir la ventana emergente
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VentanaEmergente(imagenUrl: cartas[1])),
                  );
                },
                child: Card(
                  child: Image.network(cartas[1]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: ImgVehiculos()));