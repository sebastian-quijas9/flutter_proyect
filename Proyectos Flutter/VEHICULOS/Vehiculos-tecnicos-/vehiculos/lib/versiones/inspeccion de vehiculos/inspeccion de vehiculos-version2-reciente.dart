// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../imgcoches.dart';

class InspeccionVehiculos extends StatefulWidget {
  const InspeccionVehiculos({Key? key}) : super(key: key);

  @override
  _InspeccionVehiculosState createState() => _InspeccionVehiculosState();
}

class _InspeccionVehiculosState extends State<InspeccionVehiculos> {
  String correo = "";
  String usuario = "";
  // final _formKey = GlobalKey<FormState>();
  final _sheetTextController = TextEditingController();
  String _buttonText = 'Nivel de agua';

  void _showCustomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
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
                                    text: 'Selecciona la opcion correcta',
                                    style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold, // Texto "Importante" en negrita
                                      color: Color.fromARGB(235, 0, 0, 0),
                                      fontSize: 17,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: _sheetTextController,
                              decoration: const InputDecoration(
                                labelText: 'Nivel de agua',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _buttonText =
                                      'Nivel de agua:  ${_sheetTextController.text}';
                                });
                                Navigator.pop(
                                    context); // Cerrar el DraggableSheet
                              },
                              child: const Text('Guardar'),
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
      },
    );
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
              const Text('Vehiculos'),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 3),
                  RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'NIVELES ',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showCustomDialog(context);
                  },
                  child: Text(_buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImgVehiculos()),
            );
          },
          child: const Text('Continuar'),
        ),
      ),
    );
  }
}
