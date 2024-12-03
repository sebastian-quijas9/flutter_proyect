// ignore_for_file: library_private_types_in_public_api, unused_element, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class ImgVehiculos extends StatefulWidget {
  const ImgVehiculos({Key? key}) : super(key: key);

  @override
  _ImgVehiculosState createState() => _ImgVehiculosState();
}

class _ImgVehiculosState extends State<ImgVehiculos> {
  final bool _isSending = false; // Para controlar el estado del envío
  final Color _buttonColor = const Color.fromARGB(235, 209, 4, 4);
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: const Color.fromARGB(255, 248, 1, 1),
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _enviarDatos() async {}

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
              const Text('Inspeccion vehiculo'),
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
                      backgroundColor: const Color.fromARGB(
                          0, 224, 221, 221), // Establece el fondo transparente
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
                    backgroundColor: const Color.fromRGBO(
                        22, 23, 24, 0.8), // Color del texto
                  ),
                  child: const Text('Limpiar Foto'),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      // onPressed: _clearImages,
                      onPressed: _enviarDatos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSending
                            ? Colors.grey
                            : _buttonColor, // Color de fondo del botón
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
        ),
      ),
    );
  }
}
