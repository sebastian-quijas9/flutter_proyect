// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Azar(),
    );
  }
}

class Azar extends StatefulWidget {
  const Azar({
    Key? key,
  }) : super(key: key);

  @override
  _AzarState createState() => _AzarState();
}

class _AzarState extends State<Azar> {
  List<String> secciones = ["pedales1", "pedales2", "luces"];
  List<String> seccionesMostradas = [];
  Random random = Random();
  late int indiceSeccion;

  //Nivel Agua
  String opcionSeleccionadaNivelAgua = '';
  String _buttonTextNivelAgua = 'Agua limpiavidrios ';
  List<String> opciones = ['Buen Estado', 'Mal Estado', 'Con Detalles'];

  @override
  void initState() {
    super.initState();
    // indiceSeccion = random.nextInt(secciones.length);
    // seccionesMostradas.add(secciones[indiceSeccion]);
  }

  void _showCustomDialogNivelAgua(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
           builder: (BuildContext context, StateSetter setState) {
            return Container( 
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 253, 253,
                    253), // Ajustar el valor alfa para controlar la opacidad
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.97,
                minChildSize: 0.97,
                maxChildSize: 0.97, // Mismo valor que minChildSize
                builder: (BuildContext context, ScrollController scrollController) {
                  return Column(
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(99, 43, 40, 40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Selecciona la opción correcta',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(235, 0, 0, 0),
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Agua Limpiavidrios:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(235, 153, 150, 150),
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: opciones.map((opcion) {
                                    bool seleccionada =
                                        opcion == opcionSeleccionadaNivelAgua;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          opcionSeleccionadaNivelAgua = opcion;
                                          _buttonTextNivelAgua =
                                              'Agua limpiavidrios: $opcionSeleccionadaNivelAgua';
                                        });
                                        Navigator.pop(
                                            context); // Cierra la ventana emergente
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: Card(
                                          color: seleccionada
                                              ? Colors.grey[600]
                                              : const Color.fromARGB(
                                                  255, 241, 241, 241),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              opcion,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: seleccionada
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        );
      },
    );
  }

  String seccionActual = "";
  Widget _botones() {
    if (secciones.isEmpty) {
      secciones.addAll(secciones);
      seccionesMostradas.clear();
    }

    // Encuentra una nueva sección que no haya sido mostrada anteriormente
    int indiceSeccion = random.nextInt(secciones.length);
    seccionActual = secciones[indiceSeccion];

    // Elimina la sección actual de las disponibles y agrégala a las mostradas
    secciones.remove(seccionActual);
    seccionesMostradas.add(seccionActual);

    switch (seccionActual) {
      case "pedales1":
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'PEDALES1 ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(235, 0, 0, 0),
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _showCustomDialogNivelAgua(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/limpia.png', // Reemplaza 'ruta_de_tu_imagen.png' con la ruta de tu imagen en el proyecto
                      height:
                          24, // Ajusta la altura de la imagen según tus necesidades
                      width:
                          24, // Ajusta el ancho de la imagen según tus necesidades
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _buttonTextNivelAgua,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      case "pedales2":
        // Repite el mismo patrón para las otras secciones
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'PEDALES 2',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(235, 0, 0, 0),
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            //AQUI VAN LOS BOTONES
          ],
        );
      case "luces":
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Luces ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(235, 0, 0, 0),
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //AQUI VAN LOS BOTONES
          ],
        );
      default:
        return const Text("Dale en Enviar");
    }
  }

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
              const Text(
                'Inspeccion de vehiculos',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _botones(),
              const SizedBox(height: 15),
              // ... Otros widgets ...
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: ElevatedButton(
            onPressed: ()  {
             print("opcionSeleccionadaNivelAgua: $opcionSeleccionadaNivelAgua");
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
