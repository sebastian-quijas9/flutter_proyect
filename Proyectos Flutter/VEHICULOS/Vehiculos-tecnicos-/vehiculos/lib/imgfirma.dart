// // ignore_for_file: library_private_types_in_public_api, unused_element, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, file_names

// // import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:signature/signature.dart';
// import 'package:image/image.dart' as img;

// class ImgFirma extends StatefulWidget {
//   const ImgFirma({Key? key}) : super(key: key);

//   @override
//   _ImgFirmaState createState() => _ImgFirmaState();
// }

// class _ImgFirmaState extends State<ImgFirma> {
//   final bool _isSending = false; // Para controlar el estado del envío
//   final Color _buttonColor = const Color.fromARGB(235, 209, 4, 4);
//   // ignore: unused_field
//   final _formKey = GlobalKey<FormState>();
//   final SignatureController _controller = SignatureController(
//     penStrokeWidth: 2,
//     penColor: const Color.fromARGB(255, 248, 1, 1),
//     exportBackgroundColor: const Color.fromARGB(0, 255, 255, 255),
//   );

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<Uint8List> _capturarFondo() async {
//     final ByteData data = await rootBundle.load('lib/images/auto1.png');
//     final List<int> bytes = data.buffer.asUint8List();
//     return Uint8List.fromList(bytes);
//   }

//   Future<Uint8List> _combinaFirmaConFondo(Uint8List firmaBytes, Uint8List fondoBytes) async {
//   final img.Image firmaImage = img.decodeImage(firmaBytes)!;
//   final img.Image fondoImage = img.decodeImage(fondoBytes)!;

//   // Crea una nueva imagen del mismo tamaño que el fondo
//   img.Image nuevaImagen = img.Image(fondoImage.width, fondoImage.height);

//   // Dibuja el fondo en la nueva imagen
//   img.drawImage(nuevaImagen, fondoImage, dstX: 0, dstY: 0);

//   // Dibuja la firma en la nueva imagen
//   img.drawImage(nuevaImagen, firmaImage, dstX: 0, dstY: 0);

//   // Convierte la nueva imagen a bytes
//   Uint8List imagenCombinadaBytes = Uint8List.fromList(img.encodePng(nuevaImagen));
//   return imagenCombinadaBytes;
// }

//   Future<void> _enviarDatos() async {
//     Uint8List? firmaBytes = await _controller.toPngBytes();
//     Uint8List fondoBytes = await _capturarFondo();

//     Uint8List imagenCombinadaBytes =
//         await _combinaFirmaConFondo(firmaBytes!, fondoBytes);

//     // var resultados = await Future.wait([
//     //   _controller.toPngBytes().then(
//     //       (signature) => signature != null ? base64Encode(signature) : null),
//     // ]);
//     // var imagenesNoNulas = resultados.where((imagen) => imagen != null).toList();

//     // // Envía las imágenes no nulas
//     // List<String> datosEnviados = [];
//     // for (var imagen in imagenesNoNulas) {
//     //   datosEnviados.add(imagen!);
//     // }
//     print(imagenCombinadaBytes);
//     CollectionReference coleccion =
//         FirebaseFirestore.instance.collection('Prueba');

//     await coleccion.add({
//       'prueba': imagenCombinadaBytes,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(22, 23, 24, 0.8),
//         title: ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: Row(
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Image.asset(
//                   'lib/images/ar_inicio.png',
//                   height: 44,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Text('Inspeccion vehiculo'),
//             ],
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Stack(
//                   children: [
//                     Image.asset(
//                       'lib/images/auto1.png', // Ruta de la imagen de fondo
//                       height: 300,
//                       fit: BoxFit.cover,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 1.0,
//                         ),
//                       ),
//                       child: Signature(
//                         controller: _controller,
//                         height: 300,
//                         backgroundColor: const Color.fromARGB(0, 224, 221,
//                             221), // Establece el fondo transparente
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _controller.clear(); // Restablece la firma
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: const Color.fromRGBO(
//                         22, 23, 24, 0.8), // Color del texto
//                   ),
//                   child: const Text('Limpiar Foto'),
//                 ),
//                 const SizedBox(height: 60),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _enviarDatos,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _isSending
//                             ? Colors.grey
//                             : _buttonColor, // Color de fondo del botón
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(20), // Bordes redondeados
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10), // Espaciado interno
//                         elevation: 15, // Elevación para un efecto de sombra
//                       ),
//                       child: const Text(
//                         'Enviar',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
