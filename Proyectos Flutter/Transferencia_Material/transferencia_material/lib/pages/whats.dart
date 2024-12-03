import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Whats extends StatelessWidget {
  Whats({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whats'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            enviarMensajeWhatsApp('+523314653326', '¡Hola desde mi aplicación!');
          },
          child: const Text('Enviar WhatsApp'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void enviarMensajeWhatsApp(String numeroTelefono, String mensaje) async {
    final apiUrl = 'http://wa.me/$numeroTelefono?text=${Uri.encodeComponent(mensaje)}';

    try {
      await launch(apiUrl);
      print('Intento de abrir WhatsApp realizado');
    } catch (error) {
      print('Error al intentar abrir WhatsApp: $error');
    }
  }
}
