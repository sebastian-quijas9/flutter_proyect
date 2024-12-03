// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print, use_build_context_synchronously, unused_element, unused_import

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import 'dart:convert';
import 'inspeccion de vehiculos2.dart';
import '../imgcoches.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class InspeccionVehiculos extends StatefulWidget {
  const InspeccionVehiculos({Key? key}) : super(key: key);

  @override
  _InspeccionVehiculosState createState() => _InspeccionVehiculosState();
}

class _InspeccionVehiculosState extends State<InspeccionVehiculos> {
  // final _horaFechaInicioController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
//  final bool isAdmin = FirebaseAuth.instance.currentUser?.email ==
//           'developer@asiarobotica.com' ||
//       FirebaseAuth.instance.currentUser?.email ==
//           'sebastian.quijas@asiarobotica.com' ||
//       FirebaseAuth.instance.currentUser?.email ==
//            'antonio.hernandez@asiarobotica.com' ;
  bool isAdmin = false;
  String? _conductor;
  final _fechayhora = TextEditingController();
  String? _vehiculos;
  final _kilometraje = TextEditingController();
  // String? _placas;

  //OPCIONES GENERALES
  // List<String> opciones = ['Buen Estado', 'Mal Estado', 'Con Detalles'];
  List<String> opciones = ['1/4 ', '1/2', '3/4', 'Full'];
  //Nivel liquido refrigerante de radiador
  // String opcionSeleccionadaLiquidoRefrigerante = '';
  // String _buttonTextLiquidoRefrigerante = 'Liquido refrigerante ';

  //Liquido de frenos
  String opcionSeleccionadaLiquidosFrenos = '';
  String _buttonTextLiquidosFrenos = 'Liquido de frenos ';

  //Nivel Aceite
  String opcionSeleccionadaNivelAceite = '';
  String _buttonTextNivelAceite = 'Aceite motor ';

  // String opcionSeleccionadaNivelLiquidoHidraulico = '';

  // String _buttonTextNivelLiquidoHidraulico = 'Liquido hidraulico ';

  //Nivel Agua
  String opcionSeleccionadaNivelAgua = '';
  String _buttonTextNivelAgua = 'Agua radiador ';

  //Nivel GASOLINA
  String opcionSeleccionadaNivelGasolina = '';
  String _buttonTextNivelGasolina = 'Gasolina ';

  //Carro Frontal
  // String opcionSeleccionadaCarroFrontal = '';
  // final String _buttonTextCarroFrontal = 'Carro Frontal ';
  // final SignatureController _controller = SignatureController(
  //   penStrokeWidth: 2,
  //   penColor: const Color.fromARGB(255, 248, 1, 1),
  //   exportBackgroundColor: Colors.white,
  // );

  Future<void> enviar() async {
    // var base64Results = await Future.wait([
    //   _controller.toPngBytes().then((signature) => base64Encode(signature!)),
    // ]);
    var hora = _fechayhora.text;
    var conductor = _conductor;
    _vehiculos;
    var kilometraje = _kilometraje.text;
    // opcionSeleccionadaLiquidoRefrigerante;
    opcionSeleccionadaLiquidosFrenos;
    opcionSeleccionadaNivelAceite;
    // opcionSeleccionadaNivelLiquidoHidraulico;
    opcionSeleccionadaNivelAgua;
    opcionSeleccionadaNivelGasolina;
    print(
        'Datos enviados: $hora, $conductor, $_vehiculos, $kilometraje,  $opcionSeleccionadaLiquidosFrenos, $opcionSeleccionadaNivelAceite,  $opcionSeleccionadaNivelAgua, $opcionSeleccionadaNivelGasolina');
  }

  // @override
  // void initState() {
  //   super.initState();
  //   opcionSeleccionadaNivelAgua = opciones[0];
  //   opcionSeleccionadaNivelAceite = opciones[0];
  // }

  // Future<void> enviar2() async {
  //   var hora = _fechayhora.text;
  //   _vehiculos;
  //   var kilometraje = _kilometraje.text;
  //   opcionSeleccionadaLiquidosFrenos;

  //   final database = FirebaseDatabase.instance.ref();

  //   // Guardar las URLs de las imágenes en Firebase Database junto con los demás datos
  //   await database.push().set({
  //     'horaInicio': hora,
  //     'vehiculos': _vehiculos,
  //     'kilometraje': kilometraje,
  //     'LiquidosFrenos': opcionSeleccionadaLiquidosFrenos,
  //   });
  //   print('Datos y URLs de imágenes guardados en Firebase.');
  // }

  Future<void> enviar2() async {
    var hora = _fechayhora.text;
    var kilometraje = _kilometraje.text;
    opcionSeleccionadaLiquidosFrenos;

    // Accede a la colección 'tuColeccion' en Firestore
    CollectionReference coleccion =
        FirebaseFirestore.instance.collection('Vehiculos');

    // Agrega un nuevo documento con los datos
    await coleccion.add({
      'horaInicio': hora,
      'vehiculos': _vehiculos,
      'kilometraje': kilometraje,
      'LiquidosFrenos': opcionSeleccionadaLiquidosFrenos,
    });

    print('Datos guardados en Firestore.');
  }

  @override
  void initState() {
    super.initState();
    // Actualizar la hora cada segundo
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Formatear la fecha y hora en el formato deseado
      var now = DateTime.now();
      var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      setState(() {
        _fechayhora.text = formattedDate;
      });
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          controller.text =
              DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _updateDateTimeText();
      });
    }
  }

  void _updateDateTimeText() {
    if (_selectedDate != null && _selectedTime != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);
      String formattedTime = DateFormat('HH:mm').format(
          DateTime(1, 1, 2021, _selectedTime!.hour, _selectedTime!.minute));
      String dateTimeText = '$formattedDate $formattedTime';
      _fechayhora.text = dateTimeText;
    }
  }

//AGUA RADIADOR
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
                                      text: 'Agua Radiador:',
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
                                          'Agua radiador: $opcionSeleccionadaNivelAgua';
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

//ACEITE MOTOR
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
                                      text: 'Aceite Motor:',
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
                                    opcion == opcionSeleccionadaNivelAceite;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaNivelAceite = opcion;
                                      _buttonTextNivelAceite =
                                          'Aceite motor: $opcionSeleccionadaNivelAceite';
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

//AGUA
  // void _showCustomDialogLiquidoHidraulico(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //           color: Color.fromARGB(255, 253, 253,
  //               253), // Ajustar el valor alfa para controlar la opacidad
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(50),
  //             topRight: Radius.circular(50),
  //           ),
  //         ),
  //         child: DraggableScrollableSheet(
  //           initialChildSize: 0.97,
  //           minChildSize: 0.97,
  //           maxChildSize: 0.97, // Mismo valor que minChildSize
  //           builder: (BuildContext context, ScrollController scrollController) {
  //             return Column(
  //               children: <Widget>[
  //                 Container(
  //                   width: 70,
  //                   height: 6,
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(99, 43, 40, 40),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     controller: scrollController,
  //                     child: Container(
  //                       padding: const EdgeInsets.all(16),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.stretch,
  //                         children: <Widget>[
  //                           RichText(
  //                             textAlign: TextAlign.center,
  //                             text: const TextSpan(
  //                               children: [
  //                                 TextSpan(
  //                                   text: 'Selecciona la opción correcta',
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Color.fromARGB(235, 0, 0, 0),
  //                                     fontSize: 17,
  //                                     fontStyle: FontStyle.italic,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(height: 20),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: RichText(
  //                               textAlign: TextAlign.left,
  //                               text: const TextSpan(
  //                                 children: [
  //                                   TextSpan(
  //                                     text: 'Liquido Hidraulico:',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       color:
  //                                           Color.fromARGB(235, 153, 150, 150),
  //                                       fontSize: 17,
  //                                       fontStyle: FontStyle.italic,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(height: 80),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.stretch,
  //                             children: opciones.map((opcion) {
  //                               bool seleccionada = opcion ==
  //                                   opcionSeleccionadaNivelLiquidoHidraulico;
  //                               return GestureDetector(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     opcionSeleccionadaNivelLiquidoHidraulico =
  //                                         opcion;
  //                                     _buttonTextNivelLiquidoHidraulico =
  //                                         'Liquido Hidraulico: $opcionSeleccionadaNivelLiquidoHidraulico';
  //                                   });
  //                                   Navigator.pop(
  //                                       context); // Cierra la ventana emergente
  //                                 },
  //                                 child: ClipRRect(
  //                                   borderRadius: BorderRadius.circular(50.0),
  //                                   child: Card(
  //                                     color: seleccionada
  //                                         ? Colors.grey[600]
  //                                         : const Color.fromARGB(
  //                                             255, 241, 241, 241),
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.all(16.0),
  //                                       child: Text(
  //                                         opcion,
  //                                         style: TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           color: seleccionada
  //                                               ? Colors.white
  //                                               : Colors.black,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showCustomDialogGasolina(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isDismissible: true,
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 253, 253, 253),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 20), // Espacio en la parte superior
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Container(
                    width: 2,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(235, 153, 150, 150),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
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
                                color: Color.fromARGB(235, 153, 150, 150),
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...opciones.map((opcion) {
                      bool seleccionada =
                          opcion == opcionSeleccionadaNivelGasolina;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            opcionSeleccionadaNivelGasolina = opcion;
                            _buttonTextNivelGasolina =
                                'Gasolina: $opcionSeleccionadaNivelGasolina';
                          });
                          Navigator.pop(context); // Cierra la ventana emergente
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Card(
                            color: seleccionada
                                ? Colors.grey[600]
                                : const Color.fromARGB(255, 241, 241, 241),
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
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //LIQUIDO REFRIGERANTE
  // void _showCustomDialogLiquidoRefrigerante(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //           color: Color.fromARGB(255, 253, 253,
  //               253), // Ajustar el valor alfa para controlar la opacidad
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(50),
  //             topRight: Radius.circular(50),
  //           ),
  //         ),
  //         child: DraggableScrollableSheet(
  //           initialChildSize: 0.97,
  //           minChildSize: 0.97,
  //           maxChildSize: 0.97, // Mismo valor que minChildSize
  //           builder: (BuildContext context, ScrollController scrollController) {
  //             return Column(
  //               children: <Widget>[
  //                 Container(
  //                   width: 90,
  //                   height: 6,
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(99, 43, 40, 40),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     controller: scrollController,
  //                     child: Container(
  //                       padding: const EdgeInsets.all(16),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.stretch,
  //                         children: <Widget>[
  //                           RichText(
  //                             textAlign: TextAlign.center,
  //                             text: const TextSpan(
  //                               children: [
  //                                 TextSpan(
  //                                   text: 'Selecciona la opción correcta',
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Color.fromARGB(235, 0, 0, 0),
  //                                     fontSize: 17,
  //                                     fontStyle: FontStyle.italic,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(height: 20),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: RichText(
  //                               textAlign: TextAlign.left,
  //                               text: const TextSpan(
  //                                 children: [
  //                                   TextSpan(
  //                                     text: 'Liquido Refrigerante de Radiador:',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       color:
  //                                           Color.fromARGB(235, 153, 150, 150),
  //                                       fontSize: 17,
  //                                       fontStyle: FontStyle.italic,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(height: 80),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.stretch,
  //                             children: opciones.map((opcion) {
  //                               bool seleccionada = opcion ==
  //                                   opcionSeleccionadaLiquidoRefrigerante;
  //                               return GestureDetector(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     opcionSeleccionadaLiquidoRefrigerante =
  //                                         opcion;
  //                                     _buttonTextLiquidoRefrigerante =
  //                                         'Liquido refrigerante: $opcionSeleccionadaLiquidoRefrigerante';
  //                                   });
  //                                   Navigator.pop(
  //                                       context); // Cierra la ventana emergente
  //                                 },
  //                                 child: Card(
  //                                   color: seleccionada
  //                                       ? Colors.grey[600]
  //                                       : Colors.white,
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(16.0),
  //                                     child: Text(
  //                                       opcion,
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                         color: seleccionada
  //                                             ? Colors.white
  //                                             : Colors.black,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  //LIQUIDO DE FRENOS
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
                                      text: 'Liquido de Frenos:',
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
                                    opcion == opcionSeleccionadaLiquidosFrenos;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      opcionSeleccionadaLiquidosFrenos = opcion;
                                      _buttonTextLiquidosFrenos =
                                          'Liquido frenos: $opcionSeleccionadaLiquidosFrenos';
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

  // void _showCustomDialogCarroFrontal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //           color: Color.fromARGB(255, 253, 253,
  //               253), // Ajustar el valor alfa para controlar la opacidad
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(50),
  //             topRight: Radius.circular(50),
  //           ),
  //         ),
  //         child: DraggableScrollableSheet(
  //           initialChildSize: 1,
  //           minChildSize:
  //               0.1, // Reduce este valor para permitir una expansión más hacia arriba
  //           maxChildSize: 1.0, // Mismo valor que minChildSize
  //           builder: (BuildContext context, ScrollController scrollController) {
  //             return Column(
  //               children: <Widget>[
  //                 Container(
  //                   width: 70,
  //                   height: 6,
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(99, 43, 40, 40),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     controller: scrollController,
  //                     child: Container(
  //                       padding: const EdgeInsets.all(16),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.stretch,
  //                         children: <Widget>[
  //                           RichText(
  //                             textAlign: TextAlign.center,
  //                             text: const TextSpan(
  //                               children: [
  //                                 TextSpan(
  //                                   text:
  //                                       'Selecciona los detalles que encontraste',
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Color.fromARGB(235, 0, 0, 0),
  //                                     fontSize: 17,
  //                                     fontStyle: FontStyle.italic,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(height: 20),
  //                           Container(
  //                             decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                 image: AssetImage('lib/images/auto1.png'),
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             ),
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                   color: Colors.black,
  //                                   width: 1.0,
  //                                 ),
  //                               ),
  //                               child: Signature(
  //                                 controller: _controller,
  //                                 height: 300,
  //                                 backgroundColor:
  //                                     const Color.fromARGB(0, 224, 221, 221),
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(height: 10),
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               setState(() {
  //                                 _controller.clear(); // Restablece la firma
  //                               });
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               foregroundColor: Colors.white,
  //                               backgroundColor:
  //                                   const Color.fromRGBO(22, 23, 24, 0.8),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(
  //                                     20), // Define bordes redondeados
  //                               ), // Color del texto
  //                             ),
  //                             child: const Text('Limpiar Foto'),
  //                           ),
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: const Color.fromARGB(
  //                                   255,
  //                                   175,
  //                                   174,
  //                                   174), // Cambia el color de fondo del botón
  //                               // elevation:
  //                               //     20, // Añade una sombra al botón para un aspecto tridimensional
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(
  //                                     20), // Define bordes redondeados
  //                               ),
  //                             ),
  //                             child: const Text('Guardar'),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

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
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: _horaFechaInicioController,
              //   decoration: InputDecoration(
              //     labelText: 'F&H inspeccion',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     suffixIcon: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         IconButton(
              //           icon: const Icon(Icons.calendar_today,
              //               color: Color.fromARGB(255, 206, 19, 6)),
              //           onPressed: () {
              //             _selectDate(context, _horaFechaInicioController);
              //           },
              //         ),
              //         // IconButton(
              //         //   icon: const Icon(Icons.access_time,
              //         //       color: Color.fromARGB(255, 206, 19, 6)),
              //         //   onPressed: () => _selectTime(context),
              //         // ),
              //       ],
              //     ),
              //   ),
              //   readOnly: true,
              //   onTap: () {
              //     _selectDate(context, _horaFechaInicioController);
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Por favor ingrese la fecha y hora inicio';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _fechayhora,
                decoration: InputDecoration(
                  labelText: 'Fecha y hora',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Color.fromARGB(255, 206, 19, 6)),
                        onPressed: () {
                          // _selectDate(context, _horaFechaInicioController);
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.access_time,
                      //       color: Color.fromARGB(255, 206, 19, 6)),
                      //   onPressed: () => _selectTime(context),
                      // ),
                    ],
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la fecha y hora';
                  }
                  return null;
                },
              ),
              if (isAdmin) const SizedBox(height: 15),
              if (isAdmin)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Conductor',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _conductor,
                  items: <String>["Sebastian Garcia Quijas"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _conductor = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione el Conductor';
                    }
                    return null;
                  },
                ),
              // TextFormField(
              //   controller: _conductor,
              //   decoration: InputDecoration(
              //     labelText: 'Conductor',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Por favor ingrese el destino';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Vehiculos',
                  labelStyle: GoogleFonts.roboto(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _vehiculos,
                items: <String>[
                  "RANGER -- JH07695",
                  "i 10-35 -- JPU1635",
                  "i 10-36 -- JPU1636",
                  "i 10-37 -- JPU1637",
                  "PARNERT -- JU77013",
                  "HILUX -- JL04993",
                  "AVANZA -- JNT9619",
                  "NP300 GDL -- JW22035",
                  "TORNADO -- R89AWG",
                  "PEUGEOT A20 -- A20BDM",
                  "PEUGEOT R64 -- R64BKM",
                  "PEUGEOT L04 -- L04AHT",
                  "i 10-P65 -- P65AXN",
                  "i 10-G62 -- G62BAJ",
                  "NP300 -- JT98421",
                  "TIIDA -- JSN2938"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _vehiculos = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione el Vehiculo';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),
              // TextFormField(
              //   controller: _kilometraje,
              //   decoration: InputDecoration(
              //     labelText: 'Kilometraje actual',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Por favor ingrese el kilometraje';
              //     }
              //     return null;
              //   },
              // ),
              TextFormField(
                controller: _kilometraje,
                decoration: InputDecoration(
                  labelText: 'Kilometraje actual',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType
                    .number, // Esto asegura que el teclado mostrado sea numérico
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly // Esto permite solo dígitos
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el kilometraje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

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
              // const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {
              //     _showCustomDialogLiquidoRefrigerante(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey[600],
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           'lib/images/limpia.png', // Reemplaza 'ruta_de_tu_imagen.png' con la ruta de tu imagen en el proyecto
              //           height:
              //               24, // Ajusta la altura de la imagen según tus necesidades
              //           width:
              //               24, // Ajusta el ancho de la imagen según tus necesidades
              //         ),
              //         const SizedBox(width: 10),
              //         Text(
              //           _buttonTextLiquidoRefrigerante,
              //           style: const TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
                        _buttonTextLiquidosFrenos,
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
                        _buttonTextNivelAceite,
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
              //           _buttonTextNivelLiquidoHidraulico,
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
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogNivelAgua(context);
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
                      const Icon(
                        Icons
                            .water_drop_outlined, // Añade un icono para representar el nivel de Agua
                        color: Colors.white, // Color del icono rgb(226,28,33)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextNivelAgua,
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogGasolina(context);
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
                      const Icon(
                        Icons
                            .local_gas_station, // Añade un icono para representar
                        color: Colors.white, // Color del icono
                      ),
                      const SizedBox(
                          width: 10), // Añade espacio entre el icono y el texto
                      Text(
                        _buttonTextNivelGasolina,
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

              const SizedBox(height: 30),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             const SizedBox(width: 3),
              //             RichText(
              //               textAlign: TextAlign.left,
              //               text: const TextSpan(
              //                 children: [
              //                   TextSpan(
              //                     text: 'DETALLES',
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       color: Color.fromARGB(235, 0, 0, 0),
              //                       fontSize: 17,
              //                       fontStyle: FontStyle.italic,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 10),
              //         ElevatedButton(
              //           onPressed: () {
              //             _showCustomDialogCarroFrontal(context);
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor:
              //                 Colors.grey[600], // Cambia el color de fondo del botón
              //             // elevation:
              //             //     20, // Añade una sombra al botón para un aspecto tridimensional
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.circular(20), // Define bordes redondeados
              //             ),
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 12), // Ajusta el espacio interno del botón
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 const Icon(
              //                   Icons
              //                       .time_to_leave_rounded, // Añade un icono para representar el nivel de Agua
              //                   color: Colors.white, // Color del icono rgb(226,28,33)
              //                 ),
              //                 const SizedBox(width: 10),
              //                 Text(
              //                   _buttonTextCarroFrontal,
              //                   style: const TextStyle(
              //                     fontSize: 16, // Tamaño del texto
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white, // Color del texto
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
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
              print("Hora de inicio: ${_fechayhora.text}");
              print("Kilometraje ${_kilometraje.text}");
              print("Vehiculos: $_vehiculos");
              print("Liquido Frenos: $opcionSeleccionadaLiquidosFrenos");
              print("Aceite Motor: $opcionSeleccionadaNivelAceite");
              print("Nivel Agua: $opcionSeleccionadaNivelAgua");
              print("Nivel Gasolina: $opcionSeleccionadaNivelGasolina");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspeccionVehiculosDos(
                    hora: _fechayhora.text,
                    kilometraje: _kilometraje.text,
                    liquidoFrenos: opcionSeleccionadaLiquidosFrenos,
                    vehiculos: _vehiculos ?? "",
                    aceiteMotor: opcionSeleccionadaNivelAceite,
                    nivelAgua: opcionSeleccionadaNivelAgua,
                    nivelGasolina: opcionSeleccionadaNivelGasolina,
                  ),
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
