// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EditarFormularioMaterialPage extends StatefulWidget {
  const EditarFormularioMaterialPage({Key? key, required this.formularioId})
      : super(key: key);

  final String formularioId;

  @override
  _EditarFormularioMaterialPageState createState() =>
      _EditarFormularioMaterialPageState();
}

class _EditarFormularioMaterialPageState
    extends State<EditarFormularioMaterialPage> {
  final TextEditingController _enviadoAController = TextEditingController();
  late List<String> users = [];
  String? valueChoose0;
  DateTime? _dateTime;
  String? codigo;

  @override
  void initState() {
    super.initState();
    cargarDetallesFormulario();
    _usersReadData();
  }
  String seManda = "";
  Future<void> cargarDetallesFormulario() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> formularioSnapshot =
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(widget.formularioId)
              .get();

      if (formularioSnapshot.exists) {
        final Map<String, dynamic> formularioData = formularioSnapshot.data()!;

        DateTime? fechaRequerida;
        dynamic fechaRequeridaData = formularioData['fecha_requerida'];

        if (fechaRequeridaData is DateTime) {
          fechaRequerida = fechaRequeridaData;
        } else if (fechaRequeridaData is String) {
          fechaRequerida = DateTime.tryParse(fechaRequeridaData);
          fechaRequerida ??= DateFormat('dd-MM-yyyy').parse(fechaRequeridaData);
        }
        setState(() {
          _enviadoAController.text = formularioData['se_manda_para'] ?? '';
          _dateTime = fechaRequerida;
          valueChoose0 = formularioData['se_manda_para'] ?? '';
          seManda = formularioData['se_manda_para_nombre'] ?? '';
          codigo = formularioData['materiales'][0]['codigo'] ?? '';
          print('Datos del formulario: ${formularioSnapshot.data()}');
        });
      }
    } catch (e) {
      print('Error al cargar detalles del formulario: $e');
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateTime ?? DateTime.now(),
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
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Act     Formulario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15, right: 16, bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                hint: const Text('Elige correo al que le llegará el material:'),
                dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
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
            const SizedBox(height: 16.0),
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
                      SizedBox(width: 8),
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
            if (_dateTime != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Fecha seleccionada: ${_dateTime != null ? DateFormat('dd-MM-yyyy').format(_dateTime!) : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                // padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MaterialButton(
                  onPressed: () async {
                    await guardarCambios();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home_page');

                    String formattedDate = _dateTime != null
                        ? DateFormat('dd-MM-yyyy').format(_dateTime!)
                        : '';
                    _whatsapp(
                      "$valueChoose0",
                      '¡Hola, buen día!\nSe actualizó el material($codigo) enviado para ti.\n\n*Estatus:* Re-Agendada.\n*Fecha:* $formattedDate.\n\n*Favor de ir a la aplicacion a revisar los cambios en este envio de material.*',
                    );
                    // _whatsapp(String userEmail, String mensaje)
                  },
                  // color: Theme.of(context).colorScheme.inversePrimary,
                  child: const Text(
                    'Act  formulario',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> guardarCambios() async {
    String formattedDateTime = _dateTime != null
        ? DateFormat('yyyy-MM-dd').format(_dateTime!)
        : '';
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
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.formularioId)
          .update({
        'se_manda_para': valueChoose0,
        'se_manda_para_nombre': mandaNombre,
        'fecha_requerida': formattedDateTime,
        'status': 'Re-Agendada',
      });
      print('Cambios guardados exitosamente');
    } catch (e) {
      print('Error al guardar cambios: $e');
    }
  }
}
