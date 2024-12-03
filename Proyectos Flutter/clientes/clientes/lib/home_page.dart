import 'Entregas/entregas.dart';
import 'clientes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> signOutWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  void cerrarSesion() async {
    FirebaseAuth.instance.signOut();
    await signOutWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(22, 23, 24, 0.8), // Cambio de color a negro
        title: ClipRRect(
          borderRadius: BorderRadius.circular(
              4), // Ajusta el valor del radio según tus preferencias
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
              const Text('Inicio'),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: cerrarSesion, // Asigna la función onSalirPressed al onTap
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Center(
                  child: Text(
                    'Salir',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonTheme(
              minWidth: 200.0, // Ajusta este valor según tus necesidades
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Clientes()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFf70000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Hoja de servicio',
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ButtonTheme(
              minWidth:
                  200.0, // Asegúrate de que este valor sea el mismo que el anterior
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Entregas()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF012B54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Entregas',
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            ),
            // const SizedBox(height: 30),
            // ButtonTheme(
            //   minWidth: 200.0, // Ajusta este valor según tus necesidades
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ApiZohoPage()),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            //       backgroundColor: const Color.fromARGB(255, 144, 150, 65),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       elevation: 5,
            //     ),
            //     child: Text(
            //       'Api zoho',
            //       style: GoogleFonts.roboto(fontSize: 18),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
