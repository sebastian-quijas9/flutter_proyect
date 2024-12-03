// ignore_for_file: library_private_types_in_public_api, unused_element, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, file_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl

// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';

class Vehiculo extends StatefulWidget {
  const Vehiculo({Key? key}) : super(key: key);

  @override
  _VehiculoState createState() => _VehiculoState();
}

class _VehiculoState extends State<Vehiculo> {
  bool _isButtonDisabled = false;
  bool _isSending = false; // Para controlar el estado del envío
  Color _buttonColor = const Color.fromARGB(235, 209, 4, 4);
  final List<Uint8List> _compressedImages = [];
  final List<TextEditingController> _controllers = [];
  final List<String> _nivelAguaSeleccionados = [];
  final List<String> _nivelAceiteSeleccionados = [];
  final List<String> _llantasBuenEstadoSeleccionados = [];
  final List<String> _liquidoParabrisasSeleccionados = [];
  final List<String> _revisionLucesSeleccionados = [];
  List<String> nivelAgua = ['', 'Si', 'No'];
  List<String> llantasBuenEstado = ['', 'Si', 'No'];
  List<String> nivelAceite = ['', 'Si', 'No'];
  List<String> liquidoParabrisas = ['', 'Si', 'No'];
  List<String> revisionluces = ['', 'Si', 'No'];

  // final User? user = FirebaseAuth.instance.currentUser;
  String correo = "";
  String usuario = "";
  String fase = "Vehiculos";
  String version = "v1";
  String? _vehiculos;
  String? _diasUso;
  String? _placas;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _horaFechaInicioController = TextEditingController();
  List<String> diasSeleccionados = [];
  final _horaFechaFinController = TextEditingController();
  final _destino = TextEditingController();
  String? _chofer;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> nivelesDeAguaPorDia = {};
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
      _horaFechaInicioController.text = dateTimeText;
    }
  }

  @override
  void dispose() {
    _horaFechaInicioController
        .dispose(); // Liberar el controlador cuando ya no se necesite
    super.dispose();
  }

  void _actualizarDiasSeleccionados() {
    diasSeleccionados.clear();
    _controllers.clear();
    _nivelAguaSeleccionados.clear();
    _nivelAceiteSeleccionados.clear();
    _llantasBuenEstadoSeleccionados.clear();
    _liquidoParabrisasSeleccionados.clear();
    _revisionLucesSeleccionados.clear();

    for (int i = 1; i <= int.parse(_diasUso!); i++) {
      diasSeleccionados.add('Día $i');
      _controllers.add(TextEditingController());
      _nivelAguaSeleccionados.add(nivelAgua[0]);
      _nivelAceiteSeleccionados.add(nivelAceite[0]);
      _llantasBuenEstadoSeleccionados.add(llantasBuenEstado[0]);
      _liquidoParabrisasSeleccionados.add(liquidoParabrisas[0]);
      _revisionLucesSeleccionados.add(revisionluces[0]);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_compressedImages.length >= 20) {
      Flushbar(
        message: 'No se pueden enviar más de 20 imágenes.',
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
        if (_compressedImages.length < 20) {
          _compressedImages.add(compressedImage);
        }
      });
    }
  }

  Future<void> _pickImages() async {
    if (_compressedImages.length >= 20) {
      Flushbar(
        message: 'No se pueden enviar más de 20 imágenes.',
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

    if (pickedImages != null && pickedImages.isNotEmpty) {
      int remainingSlots = 20 - _compressedImages.length;

      for (var i = 0; i < pickedImages.length && i < remainingSlots; i++) {
        File imageFile = File(pickedImages[i].path);
        Uint8List? compressedImage = await _compressImage(imageFile);

        if (compressedImage != null) {
          setState(() {
            _compressedImages.add(compressedImage);
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
    });
  }

  Future<String> _convertImageToBase64(Uint8List imageBytes) async {
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  void resetFields() {
    setState(() {
      _compressedImages.clear();
    });
  }

  Future<void> _enviarDatos() async {
    if (!_formKey.currentState!.validate() || _isButtonDisabled || _isSending) {
      return;
    }

    setState(() {
      _isButtonDisabled = true;
      _isSending = true; // Cambia el estado del envío
      _buttonColor = const Color.fromARGB(204, 175, 76, 76);
    });
    final destino = _destino.text;
    final horaFechaInicio = _horaFechaInicioController.text;
    final horaFechaFin = _horaFechaFinController.text;
    List<String> base64Images = [];

    for (int i = 0; i < _nivelAguaSeleccionados.length; i++) {
      String nivelAgua = _nivelAguaSeleccionados[i];
      nivelesDeAguaPorDia['dia${i + 1}'] = nivelAgua;
    }

    for (var imageBytes in _compressedImages) {
      String base64Image = await _convertImageToBase64(imageBytes);
      base64Images.add(base64Image);
    }
    String primerDiaNA = nivelesDeAguaPorDia['dia1'] ?? ' ';
    String segundoDiaNA = nivelesDeAguaPorDia['dia2'] ?? ' ';
    String tercerDiaNA = nivelesDeAguaPorDia['dia3'] ?? ' ';
    String cuartoDiaNA = nivelesDeAguaPorDia['dia4'] ?? ' ';
    String quintoDiaNA = nivelesDeAguaPorDia['dia5'] ?? ' ';
    String sextoDiaNA = nivelesDeAguaPorDia['dia6'] ?? ' ';
    String septimoDiaNA = nivelesDeAguaPorDia['dia7'] ?? ' ';
    String octavoDiaNA = nivelesDeAguaPorDia['dia8'] ?? ' ';

    var data = {
      'fase': fase,
      'version': version,
      'correo': correo,
      'usuario': usuario,
      'vehiculo': _vehiculos,
      'accesorio': _placas,
      'chofer': _chofer,
      'destino': destino,
      'horaFechaInicio': horaFechaInicio,
      'horaFechaFin': horaFechaFin,
      'diasUso': _diasUso,
      'primerDiaNA': primerDiaNA,
      'segundoDiaNA': segundoDiaNA,
      'tercerDiaNA': tercerDiaNA,
      'cuartoDiaNA': cuartoDiaNA,
      'quintoDiaNA': quintoDiaNA,
      'sextoDiaNA': sextoDiaNA,
      'septimoDiaNA': septimoDiaNA,
      'octavoDiaNA': octavoDiaNA,
      'imagenes': base64Images,
    };
    print("Datos a enviar: $data");
    Flushbar(
      message: 'Enviando',
      backgroundColor: const Color.fromARGB(255, 59, 199, 255),
      duration: const Duration(seconds: 17),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      flushbarPosition: FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
    // var response = await http.post(
    //   Uri.parse(
    //       'https://script.google.com/macros/s/AKfycbxCFuQiO6sLdZQDFQ366MSnwbWHZ6SceTtpS9Q2kVZtRcWvKcvFLTtz94bREft7nhCO/exec'),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode(data),
    // );
    // print('Response status: ${response.statusCode}');
    resetFields();
    Flushbar(
      message: 'Enviado Correctamente ',
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      flushbarPosition: FlushbarPosition.TOP,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);

    setState(() {
      _isButtonDisabled = false;
      _isSending = false; // Restaura el estado del envío
      _buttonColor = const Color.fromARGB(
          235, 209, 4, 4); // Restaura el color original del botón
    });
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

  @override
  Widget build(BuildContext context) {
    // correo = user?.email ?? ' ';
    // usuario = user?.displayName ?? ' ';
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                    "AVANZA",
                    "Hyundai i10 35",
                    "Hyundai i10 36",
                    "Hyundai i10 37",
                    "PEUGEOT",
                    "RANGER",
                    "NISSAN NP 300",
                    "JAC X200"
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
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Placas',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _placas,
                  items: <String>[
                    '4545',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _placas = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione la placa';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Chofer',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _chofer,
                  items: <String>[
                    '4545',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _chofer = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione la placa';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _destino,
                  decoration: InputDecoration(
                    labelText: 'Ingresa Destino',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese el destino';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _horaFechaInicioController,
                  decoration: InputDecoration(
                    labelText: 'F&H inicio',
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
                            _selectDate(context, _horaFechaInicioController);
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
                  onTap: () {
                    _selectDate(context, _horaFechaInicioController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha y hora inicio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _horaFechaFinController,
                  decoration: InputDecoration(
                    labelText: 'F&H fin',
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
                            _selectDate(context, _horaFechaFinController);
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
                  onTap: () {
                    _selectDate(context, _horaFechaFinController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha y hora fin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Alinea el RichText al lado izquierdo
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Listado para revision de vehiculo: ',
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold, // Texto "Importante" en negrita
                                color: Color.fromARGB(235, 177, 8, 8),
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            // TextSpan(
                            //   text: 'subir INE, Proforma y Paquete',
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 14,
                            //     fontStyle: FontStyle.italic,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      // Agrega más widgets aquí si es necesario
                    ],
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Dias de uso',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _diasUso,
                  items: <String>["1", "2", "3", "4", "5", "6", "7", "8"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _diasUso = newValue;
                      _actualizarDiasSeleccionados();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione los dias de uso';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    ...List.generate(diasSeleccionados.length, (index) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                                8), // Agrega relleno dentro del contorno
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(232, 235, 233,
                                  233), // Fondo gris del contorno
                              // border: Border.all(
                              //     color: Colors.grey), // Color del contorno
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados del contorno
                            ),
                            child: Center(
                              // Centra el texto dentro del contorno
                              child: Text(
                                diasSeleccionados[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  // color: Colors
                                  //     .white, // Color del texto dentro del contorno (blanco en este caso)
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   controller: _controllers[index],
                          //   decoration: InputDecoration(
                          //     labelText: 'Nivel de agua',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   // validator: (value) {
                          //   //   if (value!.isEmpty) {
                          //   //     return 'Por favor ingrese el destino';
                          //   //   }
                          //   //   return null;
                          //   // },
                          // ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Nivel de agua',
                              labelStyle: GoogleFonts.roboto(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _nivelAguaSeleccionados[index],
                            items: nivelAgua
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _nivelAguaSeleccionados[index] = newValue ??
                                    ''; // Usamos '' como valor predeterminado si newValue es nulo
                              });
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Por favor seleccione un nivel de agua';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Nivel de aceite',
                              labelStyle: GoogleFonts.roboto(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _nivelAceiteSeleccionados[index],
                            items: nivelAceite
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _nivelAceiteSeleccionados[index] = newValue ??
                                    ''; // Usamos '' como valor predeterminado si newValue es nulo
                              });
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Por favor seleccione un nivel de aceite';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Llantas en buen estado',
                              labelStyle: GoogleFonts.roboto(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _llantasBuenEstadoSeleccionados[index],
                            items: llantasBuenEstado
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _llantasBuenEstadoSeleccionados[index] = newValue ??
                                    ''; // Usamos '' como valor predeterminado si newValue es nulo
                              });
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Por favor seleccione llantas en buen estado';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Liquido parabrisas',
                              labelStyle: GoogleFonts.roboto(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _liquidoParabrisasSeleccionados[index],
                            items: liquidoParabrisas
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _liquidoParabrisasSeleccionados[index] = newValue ??
                                    ''; // Usamos '' como valor predeterminado si newValue es nulo
                              });
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Por favor seleccione liquido parabrisas';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Revision Luces',
                              labelStyle: GoogleFonts.roboto(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _revisionLucesSeleccionados[index],
                            items: revisionluces
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _revisionLucesSeleccionados[index] = newValue ??
                                    ''; // Usamos '' como valor predeterminado si newValue es nulo
                              });
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Por favor seleccione Revision luces';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    // Agrega aquí cualquier otro TextFormField adicional que necesites
                  ],
                ),
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
                    // ElevatedButton(
                    //   onPressed: () => _pickImage(ImageSource.gallery),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: const Color.fromRGBO(
                    //         22, 23, 24, 0.8), // Color de fondo del botón
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(20), // Bordes redondeados
                    //     ),
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 10), // Espaciado interno
                    //     elevation: 15, // Elevación para un efecto de sombra
                    //   ),
                    //   child: const Text(
                    //     'Galería',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
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
                    ElevatedButton(
                      onPressed: _enviarDatos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSending ? Colors.grey : _buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        elevation: 15,
                      ),
                      child: const Text(
                        'Enviar',
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
      ),
    );
  }
}
