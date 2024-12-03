import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final List<Uint8List> _compressedImages = [];

  Future<void> _pickImage(ImageSource source) async {
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

  Future<Uint8List?> _compressImage(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();

    // Comprimimos la imagen para que tenga un máximo de 800x800 píxeles
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      Uint8List.fromList(imageBytes),
      minHeight: 800,
      minWidth: 800,
      quality: 70,
    );

    return Uint8List.fromList(compressedBytes);
  }

  void _removeImage(int index) {
    setState(() {
      _compressedImages.removeAt(index);
    });
  }

  void _clearImages() {
    setState(() {
      _compressedImages.clear();
    });
  }

  void _showImageDialog(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Cerrar el diálogo al hacer clic
            },
            child: Image.memory(imageBytes),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Imágenes'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
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
                        // Mostrar la imagen en grande al hacer clic
                        _showImageDialog(_compressedImages[index]);
                      },
                      child: Image.memory(_compressedImages[index]),
                    ),
                    Positioned(
                      top: -10,
                      right: 24,
                      child: IconButton(
                        onPressed: () {
                          // Aquí también podemos agregar un diálogo de confirmación antes de eliminar
                          _removeImage(index);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Galería'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Cámara'),
              ),
              ElevatedButton(
                onPressed: _clearImages,
                child: const Text('Limpiar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
