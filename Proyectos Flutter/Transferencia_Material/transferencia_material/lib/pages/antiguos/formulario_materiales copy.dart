// ignore_for_file: avoid_print, unused_import, deprecated_member_use, non_constant_identifier_names, duplicate_ignore, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transferencia_material/components/my_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialInfo {
  String codigo;
  String cantidad;
  String descripcion;
  String funciona;
  String observaciones;
  String fotoURL;

  MaterialInfo({
    required this.codigo,
    required this.cantidad,
    required this.descripcion,
    required this.funciona,
    required this.observaciones,
    required this.fotoURL,
  });
}

class FormularioMaterial extends StatefulWidget {
  const FormularioMaterial({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _FormularioMaterialState createState() => _FormularioMaterialState();
}

// final CollectionReference users= FirebaseFirestore.instance.collection("Users").snapshots();

// Future<List<List<String>>> fetchData() async{
//  final snapshot =await FirebaseFirestore.instance.collection("Users").snapshots();

//  final users = snapshot.data!.docs;
//  print(users);
//  return [];

// }
Future<void> _whatsapp(String userEmail, String mensaje) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('usuarios').get();

    final List<String> userList = snapshot.docs
        .map<String>((doc) => doc.get('correo') as String)
        .toList();

    // Busca el correo en la lista
    if (userList.contains(userEmail)) {
      // Encuentra el documento correspondiente al correo
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          snapshot.docs.firstWhere((doc) => doc.get('correo') == userEmail);

      // Imprime los datos del usuario
      print('Datos del Usuario:');
      print('username: ${userSnapshot['nombre']}');
      print('celular: ${userSnapshot['celular']}');
      print('email: ${userSnapshot['correo']}');
      // Agrega más campos según la estructura de tu documento 'Users'

      final apiUrl =
          'http://wa.me/${userSnapshot['celular']}?text=${Uri.encodeComponent(mensaje)}';

      try {
        await launch(apiUrl);
        print('Intento de abrir WhatsApp realizado');
      } catch (error) {
        print('Error al intentar abrir WhatsApp: $error');
      }
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;
}

class _FormularioMaterialState extends State<FormularioMaterial> {
  final TextEditingController paraQuienController = TextEditingController();
  final TextEditingController numeroTicketController = TextEditingController();
  final TextEditingController folioSAIController = TextEditingController();
  final TextEditingController razonSocialController = TextEditingController();
  final TextEditingController sucursalOrigenController =
      TextEditingController();
  final TextEditingController sucursalDestinoController =
      TextEditingController();
  final TextEditingController seAvisoAController = TextEditingController();
  final TextEditingController codigoMaterialController =
      TextEditingController();
  final cantidadController = TextEditingController();
  final TextEditingController descripcionMaterialController =
      TextEditingController();
  final TextEditingController funcionaController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController descrenvioController = TextEditingController();

  String? valueChoose0;
  String? valueChoose1;
  String? valueChoose2;
  String? valueChoose3;
  String? valueChoose4;
  String? valueChooseC;
  String? valueChoose5;
  String? motivoServ;

  List<String> listItemSuc = [
    'Españoles',
    'Luis Molina',
    '8 de julio',
    'Ocotlan',
    'CDMX',
    'Monterrey'
  ];

  List<String> motivo_Servicio = [
    'Reparacion',
    'Revision',
    'Reubicacion',
    'Garantia',
    'Stock',
  ];

  List<String> listFunc = [
    'Nuevo',
    'Usado (Funcional)',
    'Usado (Dañado)',
    'Usado (Por Diagnosticar)',
    'Reparado',
    'Hueso',
    'Scrap'
  ];

// Lista para mapear las opciones principales
  List<String> listItemOpc = [
    'Paquetería',
    'Taxi/Uber',
    'Grúa/Transporte de la empresa'
  ];
  // Mapa de las subopciones
  Map<String, List<String>> opcionesSecundarias = {
    'Paquetería': ['DHL', 'Fedex', 'Estafeta', 'Amazon', 'RedPack'],
    'Taxi/Uber': ['Taxi', 'Uber', 'Didi'],
    'Grúa/Transporte de la empresa': ['Grúa', 'Auto compacto']
  };
  String hintTextForTextField = ''; // Variable para almacenar el texto del hint

  DateTime? _dateTime;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late List<String> users = [];
  String dropdownValue = '';

  final List<Uint8List> _compressedImages = [];
  List<MaterialInfo> listaMateriales = [];

  // ignore: unused_element, non_constant_identifier_names
  String _getHintText(String? ValueChoose3) {
    if (ValueChoose3 == 'Paquetería') {
      return 'Introduce número de guía:';
    } else if (valueChoose3 == 'Grúa/Transporte de la empresa') {
      return 'Introduce el nombre del chofer designado:';
    } else if (valueChoose3 == 'Taxi/Uber') {
      return 'Introduce el URL del viaje:';
    } else {
      return 'Dejar en blanco si no se conoce la info';
    }
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
    if (_compressedImages.length >= 1) {
      Flushbar(
        message: 'No se pueden enviar más de 1 imagen.',
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
        if (_compressedImages.length < 1) {
          _compressedImages.add(compressedImage);
        }
      });
    }
  }

  Future<void> _pickImages() async {
    if (_compressedImages.length >= 1) {
      Flushbar(
        message: 'No se pueden enviar más de 1 imagen.',
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

    if (pickedImages.isNotEmpty) {
      int remainingSlots = 1 - _compressedImages.length;
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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red,
            hintColor: Colors.red,
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
        });
      }
    });
  }

  Future<void> _usersReadData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('usuarios').get();

      final List<String> userList = snapshot.docs
          .map<String>((doc) => doc.get('correo') as String)
          .toList();

      setState(() {
        users = userList;
        dropdownValue = userList.isNotEmpty ? userList[0] : '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final _formkey = GlobalKey<FormState>();

  Future<String> _uploadImageToFirebaseStorage(Uint8List imageBytes) async {
    // Generar un nombre de archivo único para cada imagen
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // Obtener la referencia al lugar donde se almacenará la imagen en Firebase Storage
    final numSerie = folioSAIController.text;
    final firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(numSerie)
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

  // Future<void> _enviarFormulario() async {
  //   List<String> imageUrls = [];
  //   for (var imageBytes in _compressedImages) {
  //     String imageUrl = await _uploadImageToFirebaseStorage(imageBytes);
  //     imageUrls.add(imageUrl);
  //   }

  //   String status = 'En transito';

  //   List<MaterialInfo> copyMateriales = List.from(listaMateriales);

  //   for (var material in copyMateriales) {
  //     await FirebaseFirestore.instance.collection('formularios').add({
  //       'pa_quien': valueChoose0 ?? '',
  //       'ticket_num': numeroTicketController.text,
  //       'folio_sai': folioSAIController.text,
  //       'razon_social': razonSocialController.text,
  //       'sucursal_origen': valueChoose1 ?? '',
  //       'sucursal_destino': valueChoose2 ?? '',
  //       'motivo_servicio': motivoServ ?? '',
  //       'a_quien_se_avisa': seAvisoAController.text,
  //       'metodo_salida': valueChoose3 ?? '',
  //       'metodo_viaje': valueChoose4 ?? '',
  //       'status': status,
  //       'imagenes': imageUrls,
  //       'descripcion_transporte': descrenvioController.text,
  //       'id_material': material.codigo,
  //       'cantidad': material.cantidad,
  //       'descripcion': material.descripcion,
  //       'funciona': material.funciona,
  //       'observaciones': material.observaciones,
  //       'fechaEnvio': _dateTime,
  //       'usuario': FirebaseAuth.instance.currentUser != null
  //           ? FirebaseAuth.instance.currentUser!.email ?? ''
  //           : '',
  //     });

  //     _whatsapp(
  //       valueChoose0 ?? '',
  //       '¡Hola, buen día!\nSe genero un nuevo envio de Material(${material.codigo}) para ti.\n\n*Estatus:* En transito.\n*Fecha de envio:* ${_dateTime != null ? DateFormat('dd-MM-yyyy').format(_dateTime!) : ''}.\n*Se enviara el material a:* $valueChoose0 \n\n*Favor de ir a la aplicacion a revisar el estatus de este material.*',
  //     );
  //   }
  // }

  Future<void> _enviarFormulario() async {
    String imageUrlsString = '';
    String nombre_chofer = '';
    String nombre_tecnico = '';
    for (var imageBytes in _compressedImages) {
      String imageUrl = await _uploadImageToFirebaseStorage(imageBytes);
      imageUrlsString += imageUrl + ',';
    }

    if (imageUrlsString.isNotEmpty) {
      imageUrlsString =
          imageUrlsString.substring(0, imageUrlsString.length - 1);
    }

    String status = 'En transito';

    String usuario = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!.email ?? ''
        : '';

    String formattedDateTime =
        _dateTime != null ? DateFormat('yyyy-MM-dd').format(_dateTime!) : '';

    DateTime now = DateTime.now();

    String mandaNombre = "";

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('usuarios').get();

    final List<String> userList = snapshot.docs
        .map<String>((doc) => doc.get('correo') as String)
        .toList();

    // Busca el correo en la lista
    if (userList.contains(valueChoose0)) {
      // Encuentra el documento correspondiente al correo
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          snapshot.docs.firstWhere((doc) => doc.get('correo') == valueChoose0);

      mandaNombre = "${userSnapshot['nombre']}";
      // Imprime los datos del usuario
      print('Datos del Usuario:');
      print('username: ${userSnapshot['nombre']}');
      print('celular: ${userSnapshot['celular']}');
      print('email: ${userSnapshot['correo']}');
      // Agrega más campos según la estructura de tu documento 'Users'
    }
    if (userList.contains(usuario)) {
      // Encuentra el documento correspondiente al correo
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          snapshot.docs.firstWhere((doc) => doc.get('correo') == usuario);

      nombre_tecnico = "${userSnapshot['nombre']}";
      // Imprime los datos del usuario
      print('Datos del Usuario:');
      print('username: ${userSnapshot['nombre']}');
      print('celular: ${userSnapshot['celular']}');
      print('email: ${userSnapshot['correo']}');
      // Agrega más campos según la estructura de tu documento 'Users'
    }

    print('username: $mandaNombre');
    print('username: $nombre_tecnico');

    Map<String, dynamic> formularioData = {
      'se_manda_para': valueChoose0 ?? '',
      'se_manda_para_nombre': mandaNombre,
      'ticket': numeroTicketController.text,
      'folio_sai': folioSAIController.text,
      'razon_social': razonSocialController.text,
      'sucursal_origen': valueChoose1 ?? '',
      'sucursal_destino': valueChoose2 ?? '',
      'motivo': motivoServ ?? '',
      'nombre_chofer': nombre_chofer,
      'nombre_tecnico': nombre_tecnico,
      'se_aviso_a': seAvisoAController.text,
      'tipo_envio': valueChoose3 ?? '',
      'fecha_requerida': formattedDateTime,
      'info_adicional': valueChoose4 ?? '',
      'status': status,
      'guia_paqueteria': descrenvioController.text,
      'fecha': now,
      'email_tecnico': usuario,
    };

    List<Map<String, dynamic>> materialesData = [];

    for (var material in listaMateriales) {
      Map<String, dynamic> materialData = {
        'codigo': material.codigo,
        'cantidad': material.cantidad,
        'descripcion_material': material.descripcion,
        'fotoURL': imageUrlsString,
        'funciona': material.funciona,
        'observaciones': material.observaciones,
      };
      materialesData.add(materialData);
    }

    formularioData['materiales'] = materialesData;

    // Obtener la referencia al documento recién creado
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('tasks')
        .add(formularioData);

    String docId = docRef.id;
    print('ID del documento: $docId');
    formularioData['id'] = docId;

    await docRef.update(formularioData);

    // Notificar por WhatsApp
    for (var material in listaMateriales) {
      _whatsapp(
        valueChoose0 ?? '',
        '¡Hola, buen día!\nSe generó un nuevo envío de Material(${material.codigo}) para ti.\n\n*Estatus:* En tránsito.\n*Fecha de envío:* ${_dateTime != null ? DateFormat('dd-MM-yyyy').format(_dateTime!) : ''}.\n*Se enviará el material a:* $mandaNombre \n\n*Favor de ir a la aplicación a revisar el estatus de este material.*',
      );
    }
  }

  void _agregarMaterial() {
    String fotoURL = _compressedImages.isNotEmpty
        ? _compressedImages.removeAt(0).toString()
        : "";
    MaterialInfo nuevoMaterial = MaterialInfo(
      codigo: codigoMaterialController.text,
      cantidad: cantidadController.text,
      descripcion: descripcionMaterialController.text,
      observaciones: observacionesController.text,
      funciona: valueChoose5 ?? '',
      fotoURL: fotoURL,
    );

    setState(() {
      listaMateriales.add(nuevoMaterial);
      // Limpiar los controladores después de agregar un material
      codigoMaterialController.clear();
      cantidadController.clear();
      descripcionMaterialController.clear();
      observacionesController.clear();
      valueChoose5 = null;
      _compressedImages.clear();
      
    });
  }

  @override
  void initState() {
    super.initState();
    _usersReadData();
    print("Lista de materiales: $listaMateriales");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Materiales'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          children: [
            //Título 1 Info Gneral
            const Center(
              child: Text('Información general',
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  )),
            ),
            const SizedBox(height: 18),
            // Recuadro dropdown 1 (Sucursal de origen)
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint:
                      const Text('Elige correo al que le llegará el material:'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  value: valueChoose0,
                  onChanged: (newValue0) {
                    setState(() {
                      valueChoose0 = newValue0;
                    });
                  },
                  items: users.map<DropdownMenuItem<String>>((valueItem0) {
                    return DropdownMenuItem<String>(
                      value: valueItem0,
                      child: Text(valueItem0),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Recuadro 2 (Número de ticket)
            TextFormField(
              controller: numeroTicketController,
              decoration: InputDecoration(
                labelText: 'Escribe el número de ticket:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: const TextStyle(
                    color: Colors
                        .grey), // Cambiar el color del texto de la etiqueta a gris
              ),

              keyboardType: TextInputType
                  .number, // Esto asegura que el teclado mostrado sea numérico
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Esto permite solo dígitos
              ],
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Por favor ingrese el ticket';
              //   }
              //   return null;
              // },
            ),
            // MyTextField(
            //   hintText: "Escribe el número de ticket:",
            //   obscureText: false,
            //   controller: numeroTicketController,
            // ),
            const SizedBox(height: 25),

            // Recuadro 3 (No. Folio SAI)
            MyTextField(
              hintText: "No. de Folio de SAI",
              obscureText: false,
              controller: folioSAIController,
              //  validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Por favor, ingrese el número de folio';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 25),

            MyTextField(
              hintText: "Razón Social del Cliente",
              obscureText: false,
              controller: razonSocialController,
              //  validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Por favor, ingrese el número de folio';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 25),

            // Recuadro dropdown 1 (Sucursal de origen)
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Elige sucursal de origen:'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  value: valueChoose1,
                  onChanged: (newValue1) {
                    setState(() {
                      valueChoose1 = newValue1;
                    });
                  },
                  items: listItemSuc.map<DropdownMenuItem<String>>((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Recuadro dropdown 2 (Sucursal de destino)
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Elige sucursal de destino:'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  value: valueChoose2,
                  onChanged: (newValue2) {
                    setState(() {
                      valueChoose2 = newValue2;
                    });
                  },
                  items:
                      listItemSuc.map<DropdownMenuItem<String>>((valueItem2) {
                    return DropdownMenuItem<String>(
                      value: valueItem2,
                      child: Text(valueItem2),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Motivo de Servicio:'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  value: motivoServ,
                  onChanged: (newValue3) {
                    setState(() {
                      motivoServ = newValue3;
                    });
                  },
                  items: motivo_Servicio
                      .map<DropdownMenuItem<String>>((valueItem3) {
                    return DropdownMenuItem<String>(
                      value: valueItem3,
                      child: Text(valueItem3),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Recuadro 3 (A quien se le avisó)
            const SizedBox(height: 25),
            MyTextField(
              hintText: "Se avisó a:",
              obscureText: false,
              controller: seAvisoAController,
            ),
            const SizedBox(height: 25),

            // Recuadro dropdown 4 (Elige la maanera de mandar el paquete)

            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: valueChoose3,
                  hint: const Text('Elige cómo mandaste el paquete:'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  onChanged: (newValue3) {
                    setState(() {
                      valueChoose3 = newValue3;
                      valueChooseC = newValue3;
                      valueChoose4 =
                          (opcionesSecundarias[newValue3] ?? []).isEmpty
                              ? null
                              : opcionesSecundarias[newValue3]![0];
                    });
                  },
                  items:
                      listItemOpc.map<DropdownMenuItem<String>>((valueItem3) {
                    return DropdownMenuItem<String>(
                      value: valueItem3,
                      child: Text(valueItem3),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Segunda lista desplegable (que dependa de otra)

            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: valueChoose4,
                  hint: const Text('Elige una opción:'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  onChanged: (newValue4) {
                    setState(() {
                      valueChoose4 = newValue4;
                    });
                  },
                  items: (opcionesSecundarias[valueChoose3] ?? [])
                      .map<DropdownMenuItem<String>>((valueItem4) {
                    return DropdownMenuItem<String>(
                      value: valueItem4,
                      child: Text(valueItem4),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Cuadro de texto dependiente para localizacion de paquete
            MyTextField(
              hintText: _getHintText(valueChooseC),
              obscureText: false,
              controller: descrenvioController,
            ),
            const SizedBox(height: 25),

            // Título 2 (Información de material)
            const Center(
              child: Text('Información de material',
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  )),
            ),
            const SizedBox(height: 18),

            //
            MyTextField(
              hintText: "Código de material: ",
              obscureText: false,
              controller: codigoMaterialController,
              //  validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Por favor, ingrese el codigo de material';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 25),

            //
            TextFormField(
              controller: cantidadController,
              decoration: InputDecoration(
                labelText: 'Cantidad:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: const TextStyle(
                    color: Colors
                        .grey), // Cambiar el color del texto de la etiqueta a gris
              ),

              keyboardType: TextInputType
                  .number, // Esto asegura que el teclado mostrado sea numérico
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Esto permite solo dígitos
              ],
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Por favor ingrese el ticket';
              //   }
              //   return null;
              // },
            ),
            // MyTextField(
            //   hintText: "Cantidad",
            //   obscureText: false,
            //   controller: cantidadController,
            //    validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Por favor, ingrese la cantidad';
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(height: 25),

            //
            MyTextField(
              hintText: "Descripción de material",
              obscureText: false,
              controller: descripcionMaterialController,
              //  validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Por favor, ingrese la descripcion';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 25),

            //
            // Recuadro dropdown 2 (Sucursal de destino)
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Estado del Material'),
                  dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  value: valueChoose5,
                  onChanged: (newValue5) {
                    setState(() {
                      valueChoose5 = newValue5;
                    });
                  },
                  items: listFunc.map<DropdownMenuItem<String>>((valueItem5) {
                    return DropdownMenuItem<String>(
                      value: valueItem5,
                      child: Text(valueItem5),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            //
            MyTextField(
              hintText: "Observaciones:",
              obscureText: false,
              controller: observacionesController,
              //  validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Por favor, ingrese las observaciones';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 25),

            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MaterialButton(
                  onPressed: _agregarMaterial,
                  child: const Text(
                    'Registrar Material',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lista de materiales agregados
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listaMateriales.length,
              itemBuilder: (context, index) {
                MaterialInfo material = listaMateriales[index];
                return ListTile(
                  title: Text(
                      'Material ${index + 1} - Código: ${material.codigo}'),
                  subtitle: Text(
                      'Cantidad: ${material.cantidad}, Descripción: ${material.descripcion}, Funciona: ${material.funciona}, Observaciones: ${material.observaciones}'),
                );
              },
            ),
            const SizedBox(height: 25),
            // Botón de fecha
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MaterialButton(
                  onPressed: _showDatePicker,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ), // Ajusta el espacio entre el icono y el texto
                      Text(
                        'Elige una fecha de envío',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Mostrar la fecha seleccionada
            if (_dateTime != null)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 4,
                    ), // Ajusta el espacio entre el icono y el texto
                    Text(
                      'Fecha seleccionada: ${_dateTime != null ? DateFormat('dd-MM-yyyy').format(_dateTime!) : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
            const SizedBox(height: 25),
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
              ],
            ),

            // Botón de envío
            Center(
              child: Container(
                // padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MaterialButton(
                  onPressed: () {
                    // if (_formkey.currentState!.validate()) {

                    // } else {
                    //   // Muestra un mensaje o realiza alguna acción si la validación falla
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content:
                    //           Text('Por favor, complete todos los campos.'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    // }
                    _enviarFormulario();
                    Navigator.pop(context);
                  },
                  // color: Theme.of(context).colorScheme.inversePrimary,
                  child: const Text(
                    'Enviar formulario',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
// Lista de materiales agregados
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
