// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Uint8List> _compressedImages = [];
  final TextEditingController _numSerie = TextEditingController();

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
        backgroundColor: const Color.fromARGB(235, 209, 4, 4),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      ).show(context);
      return;
    }

    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
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

//  Future<String> _uploadImageToFirebaseStorage(Uint8List imageBytes) async {
//   // Generar un nombre de archivo único para cada imagen
//   String fileName = DateTime.now().millisecondsSinceEpoch.toString();

//   // Obtener la referencia al lugar donde se almacenará la imagen en Firebase Storage
//   final firebase_storage.Reference storageReference = firebase_storage
//       .FirebaseStorage.instance
//       .ref()
//       .child('imagenes')
//       .child('$fileName.jpg');

//   // Subir la imagen a Firebase Storage como descarga
//   final firebase_storage.UploadTask uploadTask = storageReference.putData(imageBytes,  firebase_storage.SettableMetadata(
//       contentDisposition: 'inline',
//     ),);
//   await uploadTask.whenComplete(() => print('Imagen subida exitosamente'));

//   // Obtener la URL de descarga de la imagen
//   String imageUrl = await storageReference.getDownloadURL();

//   return imageUrl;
// }

  Future<String> _uploadImageToFirebaseStorage(Uint8List imageBytes) async {
    // Generar un nombre de archivo único para cada imagen
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Obtener la referencia al lugar donde se almacenará la imagen en Firebase Storage
    final firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('imagenes')
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

  //enviar datos

  Future<void> _enviarDatos() async {
    try {
      final numSerie = _numSerie.text;
      List<String> imageUrls = [];

      // Subir imágenes a Firebase Storage
      for (var imageBytes in _compressedImages) {
        String imageUrl = await _uploadImageToFirebaseStorage(imageBytes);
        imageUrls.add(imageUrl);
      }

      var data = {
        'numSerie': numSerie,
        'imagenes': imageUrls,
      };

      CollectionReference coleccion =
          FirebaseFirestore.instance.collection('Prueba');
      await coleccion.add({
        'numSerie': numSerie,
        'imagenes': imageUrls,
      });

      print("Datos a enviar: $data");
      Flushbar(
        message: 'ENVIADO.',
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      ).show(context);
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _numSerie,
              decoration: InputDecoration(
                labelText: 'Prueba',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                ElevatedButton(
                  onPressed: _enviarDatos,
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
    );
  }
}
