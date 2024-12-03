import 'package:flutter/material.dart';

class ImgVehiculos extends StatefulWidget {
  const ImgVehiculos({Key? key}) : super(key: key);

  @override
  _ImgVehiculosState createState() => _ImgVehiculosState();
}

class _ImgVehiculosState extends State<ImgVehiculos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 23, 24, 0.8),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Container(
                color: Colors.white,
                child: Image.asset(
                  'lib/images/ar_inicio.png',
                  height: 44,
                ),
              ),
              const SizedBox(width: 10),
              const Text('INSPECCION-COCHE'),
            ],
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // Lista de cartas
              CardWithImage('lib/images/auto1.png'),
              CardWithImage('lib/images/auto2.png'),
              CardWithImage('lib/images/auto3.png'),
              CardWithImage('lib/images/auto4.png'),
              CardWithImage('lib/images/auto5.png'),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWithImage extends StatelessWidget {
  final String imagePath;

  const CardWithImage(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: <Widget>[
          // Imagen dentro de la carta
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: 200, // Altura de la imagen
            width: double.infinity, // Ancho de la imagen
          ),
          // const Padding(
          //   padding:  EdgeInsets.all(8.0),
          //   child: Text(
          //     'Descripción de la imagen', // Puedes agregar una descripción aquí
          //     style: TextStyle(fontSize: 16),
          //   ),
          // ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ImgVehiculos(),
  ));
}
