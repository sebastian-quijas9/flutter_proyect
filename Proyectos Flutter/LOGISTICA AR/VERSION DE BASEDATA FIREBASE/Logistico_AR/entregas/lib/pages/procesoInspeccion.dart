// ignore_for_file: library_private_types_in_public_api, unused_element, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, file_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class ProcesoInspeccion extends StatefulWidget {
  const ProcesoInspeccion({Key? key}) : super(key: key);

  @override
  _ProcesoInspeccionState createState() => _ProcesoInspeccionState();
}

class _ProcesoInspeccionState extends State<ProcesoInspeccion> {
  bool _isButtonDisabled = false;
  bool _isSending = false; // Para controlar el estado del envío
  Color _buttonColor = const Color.fromARGB(235, 209, 4, 4);
  final List<Uint8List> _compressedImages = [];
  final User? user = FirebaseAuth.instance.currentUser;
  String correo = "";
  String usuario = "";
  String fase = "Proceso de Inspeccion";
  final _numSerie = TextEditingController();
  String? _equipos;
  String version = "v7";
  String? _accesorio;
  String? _numRevision;
  String? _responsable;
  String? _problema;
  String? _clasificacionDefecto;
  String? _parteAfectada;
  String? _tipoDefectivo;
  // String? _dispositivoDefectivo;
  String? _clasificacionDefectivo;
  final _descripcion = TextEditingController();
  final _desviacion = TextEditingController();
  final _folioDesviacion = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      _descripcion.clear();
      _desviacion.clear();
      _parteAfectada = null;
      _problema = null;
      _clasificacionDefecto = null;
      _tipoDefectivo = null;
      // _dispositivoDefectivo = null;
      _clasificacionDefectivo = null;
      _descripcion.clear();
      _folioDesviacion.clear();
    });
  }

  Future<String> _uploadImageToFirebaseStorage(Uint8List imageBytes) async {
    // Generar un nombre de archivo único para cada imagen
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // Obtener la referencia al lugar donde se almacenará la imagen en Firebase Storage
    final numSerie = _numSerie.text;
    final firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(numSerie)
        .child(fase)
        .child('$fileName.jpg');

    // Configurar la opción contentDisposition para visualización en lugar de descarga
    final firebase_storage.UploadTask uploadTask = storageReference.putData(
      imageBytes,
      firebase_storage.SettableMetadata(
        contentDisposition: 'inline; filename=$fileName.jpg',
        contentType: 'image/jpeg', // Especificar el tipo de contenido
      ),
    );

    await uploadTask.whenComplete(() => print('Imagen subida exitosamente'));

    // Obtener la URL de descarga de la imagen
    String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
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

    final numSerie = _numSerie.text;
    final descripcion = _descripcion.text;
    final desviacion = _desviacion.text;
    final folioDesviacion = _folioDesviacion.text;
    List<String> imageUrls = [];

    // Subir imágenes a Firebase Storage
    for (var imageBytes in _compressedImages) {
      String imageUrl = await _uploadImageToFirebaseStorage(imageBytes);
      imageUrls.add(imageUrl);
    }

    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    CollectionReference coleccion = FirebaseFirestore.instance.collection(fase);
    await coleccion.add({
      'fase': fase,
      'version': version,
      'correo': correo,
      'usuario': usuario,
      'numSerie': numSerie,
      'equipos': _equipos,
      'accesorio': _accesorio,
      'descripcion': descripcion,
      'numRevision': _numRevision,
      'responsable': _responsable,
      'problema': _problema,
      'clasificacionDefecto': _clasificacionDefecto,
      'parteAfectada': _parteAfectada,
      'tipoDefectivo': _tipoDefectivo,
      'clasificacionDefectivo': _clasificacionDefectivo,
      'desviacion': desviacion,
      'folioDesviacion': folioDesviacion,
      'imagenes': imageUrls, // Agregar las imágenes en formato base64
      'fecha': formattedDateTime,
    });

    Flushbar(
      message: 'Enviando',
      backgroundColor: const Color.fromARGB(255, 59, 199, 255),
      duration: const Duration(seconds: 10),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      flushbarPosition: FlushbarPosition.BOTTOM,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);

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
    correo = user?.email ?? ' ';
    usuario = user?.displayName ?? ' ';
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
              const Text('Procesos de inspeccion'),
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
                TextFormField(
                  controller: _numSerie,
                  decoration: InputDecoration(
                    labelText: 'Número de serie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese el número de serie';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Equipo afectado',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _equipos,
                  items: <String>[
                    'ATC BOSS 1325 (ATC5 1325)',
                    'ATC BOSS 1325 Z300 (ATC5 1325 Z300)',
                    'ATC BOSS 1325R  (ATC5 1325R)',
                    'ATC BOSS X2 1325 TT (ATC5 X2 1325 TT)',
                    'ATC BOSS 2030',
                    'CREATOR 0704',
                    'CREATOR 1325',
                    'CREATOR 1409',
                    'CREATOR 1610',
                    'FIBERBLADE X0',
                    'FIBERBLADE X3',
                    'FIBERGRAVER (MFL 220)  50W',
                    'FIBERGRAVER (MFL 220) 30W',
                    'MAKER 0609',
                    'MULTIHEAD 1525',
                    'MULTIHEAD 1830',
                    'PLASMABLADE 1330',
                    'PLASMABLADE 1850',
                    'SAAP',
                    'SHOP 1325',
                    'SHOP 1330 PR',
                    'SHOP PRO 1325',
                    'STONE 1325',
                    'WORKS 1325',
                    'WORKS B 1325',
                    'BENDWORX 50T',
                    'BENDWORX 125T',
                    'BENDWORX 160T',
                    'WELDWORX'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _equipos = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione el equipo afectado';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Accesorio',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _accesorio,
                  items: <String>[
                    'Rotativo',
                    'Sistema de lubricacion',
                    'Doble tubo',
                    'Doble bomba',
                    'Doble cabezal',
                    'N/A'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _accesorio = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione el accesorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Numero de revisión',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _numRevision,
                  items: <String>['1', '2', '3', '4', '5']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _numRevision = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione el numero de revisión';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Nombre del responsable del defecto/incidente',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _responsable,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  items: <String>[
                    'BRAYAN ERNESTO SALDES LUNA',
                    'GERARDO REYNOSO LOPEZ',
                    'ALONSO SAUL SANDOVAL',
                    'ALFONSO GUZMAN ROBLEDO',
                    'VICENTE MARTINEZ ARRAZOLA',
                    'JOSE LUIS GARCIA VAZQUEZ',
                    'JOSE EDUARDO ANGUIANO MENDEZ',
                    'OSCAR ALBERTO ANGUIANO MENDEZ',
                    'JOEL ISAAC ESPARZA BRISEÑO',
                    'URIEL EMILIANO ESTARRONA VILLALVAZO',
                    'LUIS ALFONSO ROMO GONZALEZ',
                    'HECTOR EDUARDO RODRIGUEZ',
                    'MARTIN JOEL ESPARZA CARABAJAL',
                    'JORGE NAVARRETE ROSALES',
                    'JOVANIE OLIVOS ALVARADO',
                    'JAIME LEONEL MENDOZA JIMÉNEZ',
                    'OSCAR OMAR GUADALUPE ARIAS TORRES',
                    'LUIS ARMANDO FUENTES MARTINEZ',
                    'KEVIN RAFAEL TOSCANO GUTIERREZ',
                    'IGNACIO ALBERTO GONZALEZ DE LA CRUZ',
                    'DANIEL ESCOBEDO DE LOERA',
                    'ALBERTO VILLALOBOS VEGA',
                    'HUMBERTO EMMANUEL TORRES FLORES',
                    'CESAR RAMON ROJAS ENCISO',
                    'HERIBERTO CHAVIRA PARRA',
                    'RICARDO MARTINEZ SERNA',
                    'JUAN CARLOS NICASIO LOPEZ',
                    'LUIS FERNANDO RENTERIA HERNANDEZ',
                    'LOGÍSTICA INTERNA',
                    'PROVEEDOR',
                    'ALMACÉN'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _responsable = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione el nombre responsable';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Parte afectada',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _parteAfectada,
                  items: <String>[
                    'Área de trabajo',
                    'Equipo parte laterales',
                    'Equipo parte frontal',
                    'Gabinete de la mesa',
                    'Gabinete',
                    'Puente y brazos',
                    'Cabezal',
                    'Colector de polvo',
                    'Extractor de emisiones',
                    'Bomba de vacío',
                    'Chiller',
                    'Generador plasma',
                    'Pedestal',
                    'Cadena de Y y base',
                    'Alimentador de aporte',
                    'Patas y Ruedas',
                    'Rodillos',
                    'Funcionalidad',
                    'Lentes, ventanas o herramentales',
                    'Pistola',
                    'Equipo parte trasera',
                    'Controlador',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _parteAfectada = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione la parte afectada';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '¿Cuál fue la causa raíz del problema?',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _problema,
                  items: <String>[
                    'Maquina o equipo (Proveedor)',
                    'Operador en entrenamiento',
                    'Operador mal capacitado',
                    'Operador negligente',
                    'Desviación del proceso Autorizada',
                    'Mal resguardo',
                    'Mala manipulación de traslado'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _problema = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione la causa raiz del problema';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Clasificación del defecto/incidente',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _clasificacionDefecto,
                  items: <String>['Crítico', 'Mayor', 'Menor']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _clasificacionDefecto = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione la clasificacion del defecto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de defectivo',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _tipoDefectivo,
                  items: <String>['Funcional', 'Estético', 'Configuración']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _tipoDefectivo = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione el tipo de defectivo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // DropdownButtonFormField<String>(
                //   decoration: InputDecoration(
                //     labelText: '¿Disposición del defectivo?',
                //     labelStyle: GoogleFonts.roboto(fontSize: 15),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   value: _dispositivoDefectivo,
                //   items: <String>[
                //     'Retrabajo',
                //     'Calibración',
                //     'Ajuste',
                //     'Limpieza',
                //     'Aplicación de pintura',
                //     'Canibaleo',
                //     'Reemplazo',
                //     'Colocar pieza',
                //     'Configurar',
                //     'Otro (Poner en descripcion)'
                //   ].map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _dispositivoDefectivo = newValue;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Por favor seleccione el disposición del defectivo';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Clasificacion de defectivo',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  value: _clasificacionDefectivo,
                  items: <String>[
                    "Mala Instalación, error en el armado de piezas",
                    "Falta de componente",
                    "Limpieza deficiente",
                    "Equipo mal configurado o parametrizado",
                    "Tornillería mal ajustada",
                    "Mala aplicación de pintura cara B",
                    "Equipo con daños en zona A",
                    "Componente dañado",
                    "Equipo con daños en zona B",
                    "Mala aplicación de pintura cara A",
                    "Defecto de proveedor",
                    "Componente fuera de especificación",
                    "Equipo con daños en zona C",
                    "Conexiones eléctricas mal ajustadas",
                    "Mal surtido de almacén",
                    "Liberación sin pruebas de calidad",
                    "Mala aplicación de pintura cara C",
                    "Mal nivelado o escuadrado",
                    "Piezas Oxidadas",
                    "Mal etiquetado",
                    "Conexiones neumáticas mal ajustadas",
                    "Envio de equipo o refacción equivocada",
                    "Diseño de proveedor",
                    "Canibaleo interno",
                    "Manguera dañada",
                    "Transmisión con falla",
                    "Daño postventa",
                    "Error de conectividad a la red (Wi-Fi o Red)",
                    "Pulsos",
                    "Deficiencia del grabado",
                    "Amperaje fuera de rango",
                    "Deficiencia del corte",
                    "Mesa descuadrado",
                    "Compresor dañado o fuera de espec",
                    "Ventilador dañado o con mal funcionamiento",
                    "Requerimiento extraordinario del cliente",
                    "Baleros dañados",
                    "Error en base de mesa",
                    "Paro de emergencia dañado",
                    "Puerto USB dañado o con mal funcionamiento",
                    "Scan",
                    "Sensor dañado",
                    "Tubo laser dañado",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _clasificacionDefectivo = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione la clasificacion de defectivo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _descripcion,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese la descripción';
                      }
                      return null;
                    }),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _desviacion,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Desviacion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _folioDesviacion,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Folio Desviacion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
