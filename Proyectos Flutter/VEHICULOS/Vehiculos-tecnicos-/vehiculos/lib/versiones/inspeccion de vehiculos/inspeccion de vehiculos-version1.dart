// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class InspeccionVehiculos extends StatefulWidget {
  const InspeccionVehiculos({Key? key}) : super(key: key);

  @override
  _InspeccionVehiculosState createState() => _InspeccionVehiculosState();
}

class _InspeccionVehiculosState extends State<InspeccionVehiculos> {
  String correo = "";
  String usuario = "";
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _sheetTextController = TextEditingController();
  String _buttonText = 'Nivel de agua';

  void _showCustomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255,
                255), // Ajustar el valor alfa para controlar la opacidad
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.9,
            maxChildSize: 0.9, // Mismo valor que minChildSize
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 5, 5),
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
                            TextField(
                              controller: _sheetTextController,
                              decoration: const InputDecoration(
                                labelText: 'Ingrese su mensaje',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _buttonText =
                                      'Nivel de agua \n ${_sheetTextController.text}';
                                });
                                Navigator.pop(
                                    context); // Cerrar el DraggableSheet
                              },
                              child: const Text('Guardar y Cerrar'),
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
              ElevatedButton(
                onPressed: () {
                  _showCustomDialog(context);
                },
                child: Text(_buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
