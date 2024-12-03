// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print, use_build_context_synchronously, unused_element, unused_import

import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'inspeccion de vehiculos3.dart';

class InspeccionVehiculosDos extends StatefulWidget {
  final String hora;
  final String kilometraje;
  final String vehiculos;
  final String liquidoFrenos;
  final String aceiteMotor;
  final String nivelAgua;
  final String nivelGasolina;

  const InspeccionVehiculosDos(
      {super.key,
      required this.hora,
      required this.kilometraje,
      required this.vehiculos,
      required this.liquidoFrenos,
      required this.aceiteMotor,
      required this.nivelAgua,
      required this.nivelGasolina});

  @override
  _InspeccionVehiculosDosState createState() => _InspeccionVehiculosDosState();
}

class _InspeccionVehiculosDosState extends State<InspeccionVehiculosDos> {
  final List<Uint8List> _compressedImages = [];

  // ignore: unused_field
  bool _imagesAdded = false;
  // Carro Frontal
  // String opcionSeleccionadaCarroFrontal = '';
  final String _buttonTextCarroFrontal = 'Carro Frontal ';
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: const Color.fromARGB(255, 248, 1, 1),
    exportBackgroundColor: Colors.white,
  );

  final String _buttonTextCarroTrasero = 'Carro Trasero ';
  final SignatureController _controllerTrasero = SignatureController(
    penStrokeWidth: 2,
    penColor: const Color.fromARGB(255, 248, 1, 1),
    exportBackgroundColor: Colors.white,
  );

  final String _buttonTextCarroLateralDerecho = 'Carro Lateral Derecho ';
  final SignatureController _controllerLateralDerecho = SignatureController(
    penStrokeWidth: 2,
    penColor: const Color.fromARGB(255, 248, 1, 1),
    exportBackgroundColor: Colors.white,
  );

  final String _buttonTextCarroLateralIzquierdo = 'Carro Lateral Izquierdo ';
  final SignatureController _controllerLateralIzquierdo = SignatureController(
    penStrokeWidth: 2,
    penColor: const Color.fromARGB(255, 248, 1, 1),
    exportBackgroundColor: Colors.white,
  );

  final String _buttonTextCarroSuperior = 'Carro Superior ';
  final SignatureController _controllerSuperior = SignatureController(
    penStrokeWidth: 2,
    penColor: const Color.fromARGB(255, 248, 1, 1),
    exportBackgroundColor: Colors.white,
  );

  Future<String> _convertImageToBase64(Uint8List imageBytes) async {
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> enviar() async {
    var resultados = await Future.wait([
      _controller.toPngBytes().then(
          (signature) => signature != null ? base64Encode(signature) : null),
      _controllerTrasero.toPngBytes().then(
          (signature) => signature != null ? base64Encode(signature) : null),
      _controllerLateralDerecho.toPngBytes().then(
          (signature) => signature != null ? base64Encode(signature) : null),
      _controllerLateralIzquierdo.toPngBytes().then(
          (signature) => signature != null ? base64Encode(signature) : null),
      _controllerSuperior.toPngBytes().then(
          (signature) => signature != null ? base64Encode(signature) : null),
    ]);

    // Filtra los resultados para eliminar los valores null
    var imagenesNoNulas = resultados.where((imagen) => imagen != null).toList();

    // Envía las imágenes no nulas
    List<String> datosEnviados = [];
    for (var imagen in imagenesNoNulas) {
      datosEnviados.add(imagen!);
    }

    List<String> base64Images = [];
    for (var imageBytes in _compressedImages) {
      String base64Image = await _convertImageToBase64(imageBytes);
      base64Images.add(base64Image);
    }
    print('Imagenes en base64: $base64Images');
  }

  void _showImageDialog(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.memory(imageBytes),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_compressedImages.length >= 15) {
      Flushbar(
        message: 'No se pueden enviar más de 15 imágenes.',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      ).show(context);
      return;
    }

    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;

    File imageFile = File(pickedImage.path);
    Uint8List? compressedImage = await _compressImage(imageFile);

    if (compressedImage != null) {
      setState(() {
        if (_compressedImages.length < 15) {
          _compressedImages.add(compressedImage);
          _imagesAdded = true; // Imágenes agregadas
        }
      });
    }
  }

  Future<void> _pickImages() async {
    if (_compressedImages.length >= 15) {
      Flushbar(
        message: 'No se pueden enviar más de 15 imágenes.',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      ).show(context);
      return;
    }

    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    // ignore: unnecessary_null_comparison
    if (pickedImages != null && pickedImages.isNotEmpty) {
      int remainingSlots = 15 - _compressedImages.length;

      for (var i = 0; i < pickedImages.length && i < remainingSlots; i++) {
        File imageFile = File(pickedImages[i].path);
        Uint8List? compressedImage = await _compressImage(imageFile);

        if (compressedImage != null) {
          setState(() {
            _compressedImages.add(compressedImage);
            _imagesAdded = true;
          });
        }
      }
    }
  }

  Future<Uint8List?> _compressImage(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();

    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      Uint8List.fromList(imageBytes),
      minHeight: 800,
      minWidth: 800,
      quality: 30,
    );

    return Uint8List.fromList(compressedBytes);
  }

  void _removeImage(int index) {
    setState(() {
      _compressedImages.removeAt(index);
      _imagesAdded = _hasImages(); // Actualiza _imagesAdded después de eliminar
    });
  }

  bool _hasImages() {
    return _compressedImages.isNotEmpty;
  }

  void _showCustomDialogCarroFrontal(BuildContext context) {
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
            initialChildSize: 1,
            minChildSize:
                0.1, // Reduce este valor para permitir una expansión más hacia arriba
            maxChildSize: 1.0, // Mismo valor que minChildSize
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
                                    text:
                                        'Selecciona los detalles que encontraste',
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
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/images/auto1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Signature(
                                  controller: _controller,
                                  height: 300,
                                  backgroundColor:
                                      const Color.fromARGB(0, 224, 221, 221),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controller.clear(); // Restablece la firma
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(22, 23, 24, 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ), // Color del texto
                              ),
                              child: const Text('Limpiar Foto'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    119,
                                    118,
                                    118), // Cambia el color de fondo del botón
                                // elevation:
                                //     20, // Añade una sombra al botón para un aspecto tridimensional
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ),
                              ),
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

  void _showCustomDialogCarroTrasero(BuildContext context) {
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
            initialChildSize: 1,
            minChildSize:
                0.1, // Reduce este valor para permitir una expansión más hacia arriba
            maxChildSize: 1.0, // Mismo valor que minChildSize
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
                                    text:
                                        'Selecciona los detalles que encontraste',
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
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/images/auto2.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Signature(
                                  controller: _controllerTrasero,
                                  height: 300,
                                  backgroundColor:
                                      const Color.fromARGB(0, 224, 221, 221),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controllerTrasero
                                      .clear(); // Restablece la firma
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(22, 23, 24, 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ), // Color del texto
                              ),
                              child: const Text('Limpiar Foto'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    119,
                                    118,
                                    118), // Cambia el color de fondo del botón
                                // elevation:
                                //     20, // Añade una sombra al botón para un aspecto tridimensional
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ),
                              ),
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

  void _showCustomDialogCarroLateralDerecho(BuildContext context) {
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
            initialChildSize: 1,
            minChildSize:
                0.1, // Reduce este valor para permitir una expansión más hacia arriba
            maxChildSize: 1.0, // Mismo valor que minChildSize
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
                                    text:
                                        'Selecciona los detalles que encontraste',
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
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/images/auto3.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Signature(
                                  controller: _controllerLateralDerecho,
                                  height: 300,
                                  backgroundColor:
                                      const Color.fromARGB(0, 224, 221, 221),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controllerLateralDerecho
                                      .clear(); // Restablece la firma
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(22, 23, 24, 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ), // Color del texto
                              ),
                              child: const Text('Limpiar Foto'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    119,
                                    118,
                                    118), // Cambia el color de fondo del botón
                                // elevation:
                                //     20, // Añade una sombra al botón para un aspecto tridimensional
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ),
                              ),
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

  void _showCustomDialogCarroLateralIzquierdo(BuildContext context) {
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
            initialChildSize: 1,
            minChildSize:
                0.1, // Reduce este valor para permitir una expansión más hacia arriba
            maxChildSize: 1.0, // Mismo valor que minChildSize
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
                                    text:
                                        'Selecciona los detalles que encontraste',
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
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/images/auto4.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Signature(
                                  controller: _controllerLateralIzquierdo,
                                  height: 300,
                                  backgroundColor:
                                      const Color.fromARGB(0, 224, 221, 221),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controllerLateralIzquierdo
                                      .clear(); // Restablece la firma
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(22, 23, 24, 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ), // Color del texto
                              ),
                              child: const Text('Limpiar Foto'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    119,
                                    118,
                                    118), // Cambia el color de fondo del botón
                                // elevation:
                                //     20, // Añade una sombra al botón para un aspecto tridimensional
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ),
                              ),
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

  void _showCustomDialogCarroSuperior(BuildContext context) {
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
            initialChildSize: 1,
            minChildSize:
                0.1, // Reduce este valor para permitir una expansión más hacia arriba
            maxChildSize: 1.0, // Mismo valor que minChildSize
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
                                    text:
                                        'Selecciona los detalles que encontraste',
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
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/images/auto5.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Signature(
                                  controller: _controllerSuperior,
                                  height: 300,
                                  backgroundColor:
                                      const Color.fromARGB(0, 224, 221, 221),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _controllerSuperior
                                      .clear(); // Restablece la firma
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(22, 23, 24, 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ), // Color del texto
                              ),
                              child: const Text('Limpiar Foto'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    119,
                                    118,
                                    118), // Cambia el color de fondo del botón
                                // elevation:
                                //     20, // Añade una sombra al botón para un aspecto tridimensional
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Define bordes redondeados
                                ),
                              ),
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
                          text: 'DETALLES',
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
                  _showCustomDialogCarroFrontal(context);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons
                            .time_to_leave_rounded, // Añade un icono para representar el nivel de Agua
                        color: Colors.white, // Color del icono rgb(226,28,33)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextCarroFrontal,
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogCarroTrasero(context);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons
                            .time_to_leave_rounded, // Añade un icono para representar el nivel de Agua
                        color: Colors.white, // Color del icono rgb(226,28,33)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextCarroTrasero,
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogCarroLateralDerecho(context);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons
                            .time_to_leave_rounded, // Añade un icono para representar el nivel de Agua
                        color: Colors.white, // Color del icono rgb(226,28,33)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextCarroLateralDerecho,
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogCarroLateralIzquierdo(context);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons
                            .time_to_leave_rounded, // Añade un icono para representar el nivel de Agua
                        color: Colors.white, // Color del icono rgb(226,28,33)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextCarroLateralIzquierdo,
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showCustomDialogCarroSuperior(context);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons
                            .time_to_leave_rounded, // Añade un icono para representar el nivel de Agua
                        color: Colors.white, // Color del icono rgb(226,28,33)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonTextCarroSuperior,
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
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'IMPORTANTE: ',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // Texto "Importante" en negrita
                        color: Colors.grey,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'Si el vehiculo tiene daños subir la imagen',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Deshabilita el scroll del GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _compressedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showImageDialog(_compressedImages[index]);
                        },
                        child: Image.memory(_compressedImages[index]),
                      ),
                      Positioned(
                        top: -10,
                        right: 24,
                        child: IconButton(
                          onPressed: () {
                            _removeImage(index);
                          },
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 128, 10, 2)),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(22, 23, 24, 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      elevation: 15,
                    ),
                    child: const Text(
                      'Galería',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          22, 23, 24, 0.8), // Color de fondo del botón
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Bordes redondeados
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // Espaciado interno
                      elevation: 15, // Elevación para un efecto de sombra
                    ),
                    child: const Text(
                      'Cámara',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
            onPressed: () async {
              var resultados = await Future.wait([
                _controller.toPngBytes().then((signature) =>
                    signature != null ? base64Encode(signature) : null),
                _controllerTrasero.toPngBytes().then((signature) =>
                    signature != null ? base64Encode(signature) : null),
                _controllerLateralDerecho.toPngBytes().then((signature) =>
                    signature != null ? base64Encode(signature) : null),
                _controllerLateralIzquierdo.toPngBytes().then((signature) =>
                    signature != null ? base64Encode(signature) : null),
                _controllerSuperior.toPngBytes().then((signature) =>
                    signature != null ? base64Encode(signature) : null),
              ]);

              // Filtra los resultados para eliminar los valores null
              var imagenesNoNulas =
                  resultados.where((imagen) => imagen != null).toList();

              // Envía las imágenes no nulas
              List<String> datosEnviados = [];
              for (var imagen in imagenesNoNulas) {
                datosEnviados.add(imagen!);
              }

              List<String> base64Images = [];
              for (var imageBytes in _compressedImages) {
                String base64Image = await _convertImageToBase64(imageBytes);
                base64Images.add(base64Image);
              }
              print("Hora de inicio: ${widget.hora}");
              print("Kilometraje ${widget.kilometraje}");
              print("Vehiculos: ${widget.vehiculos}");
              print("Liquido Frenos: ${widget.liquidoFrenos}");
              print("Aceite Motor: ${widget.aceiteMotor}");
              print("Nivel Agua: ${widget.nivelAgua}");
              print("Nivel Gasolina: ${widget.nivelGasolina}");
              print('Imagenes con firma: $datosEnviados');
              print('Imagenes en base64: $base64Images');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspeccionVehiculosTres(
                    hora: widget.hora,
                    kilometraje: widget.kilometraje,
                    vehiculos: widget.vehiculos,
                    liquidoFrenos: widget.liquidoFrenos,
                    aceiteMotor: widget.aceiteMotor,
                    nivelAgua: widget.nivelAgua,
                    nivelGasolina: widget.nivelGasolina,
                    imagenesFirma: datosEnviados,
                    imagenesReales: base64Images,
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
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       enviar();
      //     },
      //     child: const Text('Enviar'),
      //   ),
      // ),
    );
  }
}
