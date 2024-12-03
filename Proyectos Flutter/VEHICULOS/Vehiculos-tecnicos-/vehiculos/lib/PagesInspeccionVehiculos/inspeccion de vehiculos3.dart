// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print, use_build_context_synchronously, unused_element, unused_import, deprecated_member_use

import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'dart:convert';
import 'al azar.dart';
import 'inspeccion de vehiculos2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

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
  List<String> opciones = ['Buen Estado', 'Mal Estado', 'Con Detalles'];
  List<String> secciones = ["pedales", "luces", "equipo", "varios"];
  List<String> seccionesMostradas = [];
  Random random = Random();
  late int indiceSeccion;
  final _descripcion = TextEditingController();

//--------------------------------------PEDALES-------------------------------------------------
  //Acelerador
  String opcionSeleccionadaAcelerador = '';
  String _buttonTextAcelerador = 'Acelerador ';
  //Clutsh
  String opcionSeleccionadaClutsh = '';
  String _buttonTextClutsh = 'Clutsh ';
  //Freno
  String opcionSeleccionadaFreno = '';
  String _buttonTextFreno = 'Freno ';
  //--------------------------------------LUCES-------------------------------------------------
  //LUCES ALTAS, BAJAS, MEDIAS
  String opcionSeleccionadaAMB = '';
  String _buttonTextAMB = 'Luces ';
  //Direccionales
  String opcionSeleccionadaDireccionales = '';
  String _buttonTextDireccionales = 'Direccionales ';
  //Stop
  String opcionSeleccionadaStop = '';
  String _buttonTextStop = 'Stop ';
//Luz Reserva
  String opcionSeleccionadaLuzReserva = '';
  String _buttonTextLuzReserva = 'Luz Reversa ';
//Luz Interna
  String opcionSeleccionadaLuzInterna = '';
  String _buttonTextLuzInterna = 'Luces Internas ';

  //--------------------------------------EQUIPO CARRETERA-------------------------------------------------
  //Llantas de repuesto
  String opcionSeleccionadaLlantaRepuesto = '';
  String _buttonTextLlantaRepuesto = 'Llantas Repuesto ';
  //Cruceta
  String opcionSeleccionadaCruceta = '';
  String _buttonTextCruceta = 'Cruceta';
  //Gato
  String opcionSeleccionadaGato = '';
  String _buttonTextGato = 'Gato ';

  //--------------------------------------EQUIPO CARRETERA-------------------------------------------------
  //Llantas
  String opcionSeleccionadaLlantas = '';
  String _buttonTextLlantas = 'Llantas';
  //Bateria
  String opcionSeleccionadaBateria = '';
  String _buttonTextBateria = 'Bateria';
  //Rines
  String opcionSeleccionadaRines = '';
  String _buttonTextRines = 'Rines ';
  //Tapizado
  String opcionSeleccionadaTapizado = '';
  String _buttonTextTapizado = 'Tapizado';

  Future<void> enviar() async {
    print("Hora de inicio: ${widget.hora}");
    print("Kilometraje ${widget.kilometraje}");
    print("Vehiculos: ${widget.vehiculos}");
    print("Liquido Frenos: ${widget.liquidoFrenos}");
    print("Aceite Motor: ${widget.aceiteMotor}");
    print("Nivel Agua: ${widget.nivelAgua}");
    print("Nivel Gasolina: ${widget.nivelGasolina}");
    print('Imagenes con firma: ${widget.imagenesFirma} ');
    print('Imagenes en base64: ${widget.imagenesReales}');
    final descripcion = _descripcion.text;
    print('Descripcion  : $descripcion');
  }

  // Future<void> enviar2() async {
  //   final database = FirebaseDatabase.instance.reference();

  //   // Guardar las URLs de las imágenes en Firebase Database junto con los demás datos
  //   String descripcion = _descripcion.text;
  //   await database.push().set({
  //     'horaInicio': widget.hora,
  //     'kilometraje': widget.kilometraje,
  //     'vehiculos': widget.vehiculos,
  //     'liquidoFrenos': widget.liquidoFrenos,
  //     'aceiteMotor': widget.aceiteMotor,
  //     'nivelAgua': widget.nivelAgua,
  //     'nivelGasolina': widget.nivelGasolina,
  //     // 'imagenesFirma': urlsFirma,
  //     // 'imagenesReales': urlsReales,
  //     'descripcion': descripcion,
  //   });

  //   print('Datos y URLs de imágenes guardados en Firebase.');
  // }

  Future<void> enviar2() async {
    String descripcion = _descripcion.text;
    CollectionReference coleccion =
        FirebaseFirestore.instance.collection('Vehiculos');

    //"pedales", "luces", "equipo", "varios"
    List<String> imagenesBase64Firma = [];
    List<String> imagenesBase64Real = [];

    for (var imagenFirma in widget.imagenesFirma) {
      imagenesBase64Firma.add(imagenFirma);
    }
    for (var imagenReal in widget.imagenesReales) {
      imagenesBase64Real.add(imagenReal);
    }

    try {
      if (seccionActual == "pedales") {
        await coleccion.add({
          'horaInicio': widget.hora,
          'kilometraje': widget.kilometraje,
          'vehiculos': widget.vehiculos,
          'liquidoFrenos': widget.liquidoFrenos,
          'imagenesFirma': imagenesBase64Firma,
          'imagenesReales': imagenesBase64Real,
          'aceiteMotor': widget.aceiteMotor,
          'nivelAgua': widget.nivelAgua,
          'nivelGasolina': widget.nivelGasolina,
          'descripcion': descripcion,
          'Acelerador': opcionSeleccionadaAcelerador,
          'Clutsh': opcionSeleccionadaClutsh,
          'Freno': opcionSeleccionadaFreno,
        });
      } else if (seccionActual == "luces") {
        await coleccion.add({
          'horaInicio': widget.hora,
          'kilometraje': widget.kilometraje,
          'vehiculos': widget.vehiculos,
          'liquidoFrenos': widget.liquidoFrenos,
          'imagenesFirma': imagenesBase64Firma,
          'imagenesReales': imagenesBase64Real,
          'aceiteMotor': widget.aceiteMotor,
          'nivelAgua': widget.nivelAgua,
          'nivelGasolina': widget.nivelGasolina,
          'descripcion': descripcion,
          'AMB': opcionSeleccionadaAMB,
          'Direccionales': opcionSeleccionadaDireccionales,
          'Stop': opcionSeleccionadaStop,
          'LuzReserva': opcionSeleccionadaLuzReserva,
          'LuzInterna': opcionSeleccionadaLuzInterna,
        });
      } else if (seccionActual == "equipo") {
        await coleccion.add({
          'horaInicio': widget.hora,
          'kilometraje': widget.kilometraje,
          'vehiculos': widget.vehiculos,
          'liquidoFrenos': widget.liquidoFrenos,
          'imagenesFirma': imagenesBase64Firma,
          'imagenesReales': imagenesBase64Real,
          'aceiteMotor': widget.aceiteMotor,
          'nivelAgua': widget.nivelAgua,
          'nivelGasolina': widget.nivelGasolina,
          'descripcion': descripcion,
          'LlantaRepuesto': opcionSeleccionadaLlantaRepuesto,
          'Cruceta': opcionSeleccionadaCruceta,
          'Gato': opcionSeleccionadaGato,
        });
      } else if (seccionActual == "varios") {
        await coleccion.add({
          'horaInicio': widget.hora,
          'kilometraje': widget.kilometraje,
          'vehiculos': widget.vehiculos,
          'liquidoFrenos': widget.liquidoFrenos,
          'aceiteMotor': widget.aceiteMotor,
          'nivelAgua': widget.nivelAgua,
          'imagenesFirma': imagenesBase64Firma,
          'imagenesReales': imagenesBase64Real,
          'nivelGasolina': widget.nivelGasolina,
          'descripcion': descripcion,
          'Llantas': opcionSeleccionadaLlantas,
          'Bateria': opcionSeleccionadaBateria,
          'Rines': opcionSeleccionadaRines,
          'Tapizado': opcionSeleccionadaTapizado,
        });
      }
      print('Datos guardados en Firestore.');
    } catch (e) {
      print('Datos no se enviaron por el error -> $e');
    }

    // // Agrega un nuevo documento con los datos
    // await coleccion.add({
    //   'horaInicio': widget.hora,
    //   'kilometraje': widget.kilometraje,
    //   'vehiculos': widget.vehiculos,
    //   'liquidoFrenos': widget.liquidoFrenos,
    //   'aceiteMotor': widget.aceiteMotor,
    //   'nivelAgua': widget.nivelAgua,
    //   'nivelGasolina': widget.nivelGasolina,
    //   'descripcion': descripcion,
    //   'opcionSeleccionadaAcelerador': opcionSeleccionadaAcelerador,
    // });
  }

//--------------------------------------PEDALES-------------------------------------------------
  void _showCustomDialogAcelerador(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Acelerador:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
        });
      },
    );
  }

  void _showCustomDialogClutsh(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaClutsh;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaClutsh = opcion;
                                        _buttonTextClutsh =
                                            'Clutsh: $opcionSeleccionadaClutsh';
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
        });
      },
    );
  }

  void _showCustomDialogFreno(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
        });
      },
    );
  }

  //--------------------------------------LUCES-------------------------------------------------
  void _showCustomDialogAMB(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Luces (Altas, Medias, Bajas):',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaAMB;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaAMB = opcion;
                                        _buttonTextAMB =
                                            'Luces: $opcionSeleccionadaAMB';
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
        });
      },
    );
  }

  void _showCustomDialogDireccionales(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Direccionales:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaDireccionales;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaDireccionales =
                                            opcion;
                                        _buttonTextDireccionales =
                                            'Direccionales: $opcionSeleccionadaDireccionales';
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
        });
      },
    );
  }

  void _showCustomDialogStop(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Stop (Frenos):',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaStop;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaStop = opcion;
                                        _buttonTextStop =
                                            'Stop: $opcionSeleccionadaStop';
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
        });
      },
    );
  }

  void _showCustomDialogLuzReserva(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Luz De Reversa:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaLuzReserva;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaLuzReserva = opcion;
                                        _buttonTextLuzReserva =
                                            'LuzReserva: $opcionSeleccionadaLuzReserva';
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
        });
      },
    );
  }

  void _showCustomDialogLuzInternas(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Luces Internas:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaLuzInterna;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaLuzInterna = opcion;
                                        _buttonTextLuzInterna =
                                            'LuzInternas: $opcionSeleccionadaLuzInterna';
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
        });
      },
    );
  }

  //--------------------------------------EQUIPO CARRETERA-------------------------------------------------
  void _showCustomDialogLlantaRepuesto(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'LlantaRepuesto:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                  bool seleccionada = opcion ==
                                      opcionSeleccionadaLlantaRepuesto;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaLlantaRepuesto =
                                            opcion;
                                        _buttonTextLlantaRepuesto =
                                            'Llanta Repuesto: $opcionSeleccionadaLlantaRepuesto';
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
        });
      },
    );
  }

  void _showCustomDialogCruceta(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Cruceta:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaCruceta;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaCruceta = opcion;
                                        _buttonTextCruceta =
                                            'Cruceta: $opcionSeleccionadaCruceta';
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
        });
      },
    );
  }

  void _showCustomDialogGato(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Gato:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaGato;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaGato = opcion;
                                        _buttonTextGato =
                                            'Gato: $opcionSeleccionadaGato';
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
        });
      },
    );
  }

  //--------------------------------------VARIOS-------------------------------------------------
  void _showCustomDialogLlantas(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Llantas:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaLlantas;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaLlantas = opcion;
                                        _buttonTextLlantas =
                                            'Llantas : $opcionSeleccionadaLlantas';
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
        });
      },
    );
  }

  void _showCustomDialogBateria(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Bateria:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaBateria;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaBateria = opcion;
                                        _buttonTextBateria =
                                            'Bateria: $opcionSeleccionadaBateria';
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
        });
      },
    );
  }

  void _showCustomDialogRines(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Rines:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaRines;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaRines = opcion;
                                        _buttonTextRines =
                                            'Rines: $opcionSeleccionadaRines';
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
        });
      },
    );
  }

  void _showCustomDialogTapizado(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                        text: 'Tapizado:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              235, 153, 150, 150),
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
                                      opcion == opcionSeleccionadaTapizado;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opcionSeleccionadaTapizado = opcion;
                                        _buttonTextTapizado =
                                            'Tapizado : $opcionSeleccionadaTapizado';
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
        });
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
      //"pedales", "luces", "equipo", "varios"
      case "pedales":
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
                        text: 'PEDALES',
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
                _showCustomDialogAcelerador(context);
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
                _showCustomDialogClutsh(context);
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showCustomDialogFreno(context);
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
                      _buttonTextFreno,
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
                        text: 'LUCES',
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
                _showCustomDialogAMB(context);
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
                      _buttonTextAMB,
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
                _showCustomDialogDireccionales(context);
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
                      _buttonTextDireccionales,
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
                _showCustomDialogStop(context);
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
                      _buttonTextStop,
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
                _showCustomDialogLuzReserva(context);
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
                      _buttonTextLuzReserva,
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
                _showCustomDialogLuzInternas(context);
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
                      _buttonTextLuzInterna,
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
      case "equipo":
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
                        text: 'EQUIPO EN CARRETERA ',
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
                _showCustomDialogLlantaRepuesto(context);
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
                      _buttonTextLlantaRepuesto,
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
                _showCustomDialogCruceta(context);
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
                      _buttonTextCruceta,
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
                _showCustomDialogGato(context);
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
                      _buttonTextGato,
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
      case "varios":
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
                        text: 'VARIOS',
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
                _showCustomDialogLlantas(context);
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
                      _buttonTextLlantas,
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
                _showCustomDialogBateria(context);
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
                      _buttonTextBateria,
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
                _showCustomDialogRines(context);
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
                      _buttonTextRines,
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
                _showCustomDialogTapizado(context);
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
                      _buttonTextTapizado,
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcion,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: ElevatedButton(
            onPressed: () {
              enviar2();
              // if (seccionActual == "pedales") {
              //   print(
              //       "opcionSeleccionadaAcelerador: $opcionSeleccionadaAcelerador");
              //   print("opcionSeleccionadaClutsh: $opcionSeleccionadaClutsh");
              //   print("opcionSeleccionadaFrenor: $opcionSeleccionadaFreno");
              // }
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color.fromARGB(255, 101, 204, 17)),
            child: const Text(
              'Enviar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
