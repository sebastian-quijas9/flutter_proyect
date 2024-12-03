// ignore_for_file: avoid_print, must_be_immutable, use_key_in_widget_constructors, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa la librería para formateo de fechas

class MisCancelados extends StatelessWidget {
  MisCancelados({Key? key});

  Stream<QuerySnapshot> getPostsStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final postsStream = FirebaseFirestore.instance
          .collection('tasks')
          .where('email_tecnico', isEqualTo: user.email)
          .orderBy('fecha_requerida', descending: true)
          .snapshots();
      return postsStream;
    } else {
      return const Stream.empty();
    }
  }

  late DocumentReference<Map<String, dynamic>> formularioReference;

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

  void _mostrarDetalles(BuildContext context, DocumentSnapshot formulario) {
   formularioReference =
        FirebaseFirestore.instance.collection('tasks').doc(formulario.id);
     String timestamp = formulario['fecha_requerida'];
     DateTime dateTime = DateTime.parse(timestamp);
     String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
   

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Center(
                  child: Text(
                    'Detalles del Material enviado',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text('Enviado a: ${formulario['se_manda_para_nombre'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text('Ticket: ${formulario['ticket'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text('Folio SAI: ${formulario['folio_sai'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text('Fecha: $formattedDate'),
                const SizedBox(height: 8.0),
                Text('Sucursal Origen: ${formulario['sucursal_origen'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text(
                    'Sucursal Destino: ${formulario['sucursal_destino'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text('Método de Salida: ${formulario['tipo_envio'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text('Se le aviso a:  ${formulario['se_aviso_a'] ?? ''}'),
                const SizedBox(height: 8.0),
                Text(
                  'Estatus: ${formulario['status'] ?? ''}',
                  style: TextStyle(
                    color: _getColorForStatus(formulario['status']),
                  ),
                ),
                const Center(
                  child: Text(
                    'Motivo de la transferencia',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Motivo:  ${formulario['motivo'] ?? ''}'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Lista de los Materiales',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (formulario['materiales'] != null &&
                        formulario['materiales'].isNotEmpty)
                      ...(formulario['materiales'] as List<dynamic>)
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> material = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Registro: ${index + 1}'),
                            const SizedBox(height: 4.0),
                            Text('Código: ${material['cantidad'] ?? ''}'),
                            const SizedBox(height: 8.0),
                            Text(
                                'Descripción de Material: ${material['descripcion_material'] ?? ''}'),
                            const SizedBox(height: 8.0),
                            Text(
                                'Estado del Material: ${material['funciona'] ?? ''}'),
                            const SizedBox(height: 8.0),
                            Text(
                                'Observaciones: ${material['observaciones'] ?? ''}'),
                            const SizedBox(height: 20.0),
                          ],
                        );
                      }),
                  ],
                ),
                Text('Lo envío: ${formulario['nombre_tecnico'] ?? ''}'),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                       
                        formularioReference.update({'status': 'En transito'});
                        Navigator.pop(context); // Cerrar el BottomSheet

                        _whatsapp(
                          "${formulario['se_manda_para']}",
                          '¡Hola, buen día!\nEl material salio de estatus *Cancelada* \n\nSe volvio a activar el envio del material(${formulario['materiales'][0]['codigo']}).\n\n*Estatus:* En-Transito.\n*Fecha:* $formattedDate.\n*Se enviara el material a:* ${formulario['se_manda_para_nombre']}. \n\n*Favor de ir a la aplicacion a revisar los cambios en este envio de material.*',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Regresar a En transito'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Lógica para cancelar y eliminar de Firestore
                    //     formularioReference.update({'status': 'Cancelado'});
                    //     // Lógica para cancelar y eliminar de Firestore
                    //     // _cancelarYEliminar(formulario);
                    //     Navigator.pop(context); // Cerrar el BottomSheet
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.orange,
                    //   ),
                    //   child: const Text('Cancelar'),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorForStatus(String? status) {
    switch (status) {
      case 'Aprobado':
        return const Color.fromARGB(255, 136, 173, 137);
      case 'Recibido':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      case 'Rechazado':
        return Colors.orange;
      case 'Re-Agendada':
        return Colors.yellow;
      default:
        return const Color.fromARGB(255, 1, 83, 235);
    }
  }

  void _cancelarYEliminar(DocumentSnapshot formulario) async {
    try {
      await formulario.reference.delete();
      print('Documento eliminado correctamente de Firestore');
    } catch (e) {
      print('Error al eliminar el documento de Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cancelados'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final List<DocumentSnapshot> formularios = snapshot.data!.docs;
          final List<DocumentSnapshot> formulariosFiltrados = formularios
              .where((formulario) => formulario['status'] != 'En transito')
              .where((formulario) => formulario['status'] != 'Aprobado')
              .where((formulario) => formulario['status'] != 'Re-Agendada')
              .where((formulario) => formulario['status'] != 'Recibido')
              .toList();

          return ListView.builder(
            itemCount: formulariosFiltrados.length,
            itemBuilder: (context, index) {
              final formulario = formulariosFiltrados[index];

              return InkWell(
                onTap: () {
                  _mostrarDetalles(context, formulario);
                },
                child: Card(
                  child: ListTile(
                    title: Text('Enviado a: ${formulario['se_manda_para_nombre'] ?? ''}'),
                    tileColor: Theme.of(context).colorScheme.secondary,
                    subtitle: Text(
                        'El material (${formulario['materiales'][0]['codigo']  ?? ''}) fue enviado desde ${formulario['sucursal_origen'] ?? ''} hasta  ${formulario['sucursal_destino'] ?? ''} en ${formulario['tipo_envio'] ?? ''}'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
