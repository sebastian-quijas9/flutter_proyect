// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print, use_build_context_synchronously, unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'dart:convert';
import '../../PagesInspeccionVehiculos/al azar.dart';
import '../../PagesInspeccionVehiculos/inspeccion de vehiculos2.dart';

class InspeccionVehiculosTres extends StatefulWidget {
  final String hora;
  final String kilometraje;
  final String vehiculos;
  final String liquidoFrenos;
  final String aceiteMotor;
  final String nivelAgua;
  final String nivelGasolina;
  final List<String> imagenesFirma; // Debe ser una lista de cadenas
  final List<String> imagenesReales; // Debe ser una lista de cadenas

  const InspeccionVehiculosTres({
    super.key,
    required this.hora,
    required this.kilometraje,
    required this.vehiculos,
    required this.liquidoFrenos,
    required this.aceiteMotor,
    required this.nivelAgua,
    required this.nivelGasolina,
    required this.imagenesFirma,
    required this.imagenesReales,
  });

  @override
  _InspeccionVehiculosTresState createState() =>
      _InspeccionVehiculosTresState();
}

class _InspeccionVehiculosTresState extends State<InspeccionVehiculosTres> {
  // String? _placas;

  //OPCIONES GENERALES
  List<String> opciones = ['Buen Estado', 'Mal Estado', 'Con Detalles'];
  // List<String> opciones = ['1/4 ', '1/2', '3/4', 'Full'];
  //Acelerador
  String opcionSeleccionadaAcelerador = '';
  String _buttonTextAcelerador = 'Acelerador ';

  //Clutsh
  String opcionSeleccionadaCluths = '';
  String _buttonTextClutsh = 'Clutsh ';

  //Freno
  String opcionSeleccionadaFreno = '';
  String _buttonTextFreno = 'Freno ';

  //Nivel Aceite
  String opcionSeleccionadaLuces = '';
  String _buttonTextLuces = 'Luces ';

  //Nivel Agua
  String opcionSeleccionadaNivelAgua = '';
  String _buttonTextNivelAgua = 'Agua limpiavidrios ';

  //Nivel GASOLINA
  String opcionSeleccionadaNivelGasolina = '';
  String _buttonTextNivelGasolina = 'Gasolina ';

  Future<void> enviar() async {}

//AGUA LIMPIAVIDRIOS
  void _showCustomDialogNivelAgua(BuildContext context) {
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
      },
    );
  }

//Freno
  void _showCustomDialogNivelAceite(BuildContext context) {
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
                    width: 90,
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
                                      text: 'Freno:',
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
                                    opcion == opcionSeleccionadaFreno;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaFreno = opcion;
                                      _buttonTextFreno =
                                          'Freno: $opcionSeleccionadaFreno';
                                    });
                                    Navigator.pop(
                                        context); // Cierra la ventana emergente
                                  },
                                  child: Card(
                                    color: seleccionada
                                        ? Colors.grey[600]
                                        : Colors.white,
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
      },
    );
  }

//AGUA LIMPIAVIDRIOS
  void _showCustomDialogLiquidoHidraulico(BuildContext context) {
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
                                      text: 'Luces: (Altas, Medias, Bajas)',
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
                                    opcion == opcionSeleccionadaLuces;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaLuces = opcion;
                                      _buttonTextLuces =
                                          'Luces: $opcionSeleccionadaLuces';
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
      },
    );
  }

  //AGUA LIMPIAVIDRIOS
  void _showCustomDialogGasolina(BuildContext context) {
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
                                      text: 'Gasolina:',
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
                                    opcion == opcionSeleccionadaNivelGasolina;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaNivelGasolina = opcion;
                                      _buttonTextNivelGasolina =
                                          'Gasolina: $opcionSeleccionadaNivelGasolina';
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
      },
    );
  }

  //Acelerador
  void _showCustomDialogLiquidoRefrigerante(BuildContext context) {
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
                    width: 90,
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
                                      text: 'Acelerador:',
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
                                    opcion == opcionSeleccionadaAcelerador;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaAcelerador = opcion;
                                      _buttonTextAcelerador =
                                          'Acelerador: $opcionSeleccionadaAcelerador';
                                    });
                                    Navigator.pop(
                                        context); // Cierra la ventana emergente
                                  },
                                  child: Card(
                                    color: seleccionada
                                        ? Colors.grey[600]
                                        : Colors.white,
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
      },
    );
  }

  //Clutsh
  void _showCustomDialogLiquidoFrenos(BuildContext context) {
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
                    width: 90,
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
                                      text: 'Clutsh:',
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
                                    opcion == opcionSeleccionadaCluths;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaCluths = opcion;
                                      _buttonTextClutsh =
                                          'Liquido frenos: $opcionSeleccionadaCluths';
                                    });
                                    Navigator.pop(
                                        context); // Cierra la ventana emergente
                                  },
                                  child: Card(
                                    color: seleccionada
                                        ? Colors.grey[600]
                                        : Colors.white,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 3),
                  RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'PEDALES ',
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogLiquidoRefrigerante(context);
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
                        _buttonTextAcelerador,
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
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogLiquidoFrenos(context);
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
                        'lib/images/frenos-liquido1.png', // Reemplaza 'ruta_de_tu_imagen.png' con la ruta de tu imagen en el proyecto
                        height:
                            24, // Ajusta la altura de la imagen según tus necesidades
                        width:
                            24, // Ajusta el ancho de la imagen según tus necesidades
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextClutsh,
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogNivelAceite(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey[600], // Cambia el color de fondo del botón
                  // elevation:
                  //     20, // Añade una sombra al botón para un aspecto tridimensional
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Define bordes redondeados
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12), // Ajusta el espacio interno del botón
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/aceite-motor.png', // Reemplaza 'ruta_de_tu_imagen.png' con la ruta de tu imagen en el proyecto
                        height:
                            24, // Ajusta la altura de la imagen según tus necesidades
                        width:
                            24, // Ajusta el ancho de la imagen según tus necesidades
                      ),
                      const SizedBox(
                          width: 10), // Añade espacio entre el icono y el texto
                      Text(
                        _buttonTextFreno,
                        style: const TextStyle(
                          fontSize: 16, // Tamaño del texto
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Color del texto
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const SizedBox(width: 3),
              //     RichText(
              //       textAlign: TextAlign.left,
              //       text: const TextSpan(
              //         children: [
              //           TextSpan(
              //             text: 'LUCES ',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               color: Color.fromARGB(235, 0, 0, 0),
              //               fontSize: 17,
              //               fontStyle: FontStyle.italic,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 15),
              // ElevatedButton(
              //   onPressed: () {
              //     _showCustomDialogLiquidoHidraulico(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor:
              //         Colors.grey[600], // Cambia el color de fondo del botón
              //     // elevation:
              //     //     20, // Añade una sombra al botón para un aspecto tridimensional
              //     shape: RoundedRectangleBorder(
              //       borderRadius:
              //           BorderRadius.circular(20), // Define bordes redondeados
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //         vertical: 12), // Ajusta el espacio interno del botón
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           'lib/images/liquidoHidraulico.png', // Reemplaza 'ruta_de_tu_imagen.png' con la ruta de tu imagen en el proyecto
              //           height:
              //               24, // Ajusta la altura de la imagen según tus necesidades
              //           width:
              //               24, // Ajusta el ancho de la imagen según tus necesidades
              //         ),
              //         const SizedBox(width: 10),
              //         Text(
              //           _buttonTextLuces,
              //           style: const TextStyle(
              //             fontSize: 16, // Tamaño del texto
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white, // Color del texto
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
              // ElevatedButton(
              //   onPressed: () {
              //     _showCustomDialogNivelAgua(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor:
              //         Colors.grey[600], // Cambia el color de fondo del botón
              //     // elevation:
              //     //     20, // Añade una sombra al botón para un aspecto tridimensional
              //     shape: RoundedRectangleBorder(
              //       borderRadius:
              //           BorderRadius.circular(20), // Define bordes redondeados
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //         vertical: 12), // Ajusta el espacio interno del botón
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Icon(
              //           Icons
              //               .water_drop_outlined, // Añade un icono para representar el nivel de Agua
              //           color: Colors.white, // Color del icono rgb(226,28,33)
              //         ),
              //         const SizedBox(width: 10),
              //         Text(
              //           _buttonTextNivelAgua,
              //           style: const TextStyle(
              //             fontSize: 16, // Tamaño del texto
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white, // Color del texto
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
              // ElevatedButton(
              //   onPressed: () {
              //     _showCustomDialogGasolina(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor:
              //         Colors.grey[600], // Cambia el color de fondo del botón
              //     // elevation:
              //     //     20, // Añade una sombra al botón para un aspecto tridimensional
              //     shape: RoundedRectangleBorder(
              //       borderRadius:
              //           BorderRadius.circular(20), // Define bordes redondeados
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //         vertical: 12), // Ajusta el espacio interno del botón
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Icon(
              //           Icons
              //               .local_gas_station, // Añade un icono para representar el nivel de aceite
              //           color: Colors.white, // Color del icono
              //         ),
              //         const SizedBox(
              //             width: 10), // Añade espacio entre el icono y el texto
              //         Text(
              //           _buttonTextNivelGasolina,
              //           style: const TextStyle(
              //             fontSize: 16, // Tamaño del texto
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white, // Color del texto
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       enviar();
      //     },
      //     child: const Text('Enviar'),
      //   ),
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Azar(),
                ),
              );
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
