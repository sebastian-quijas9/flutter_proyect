import 'package:asia_robotica_clientes/pages/clientes.dart';
import 'package:asia_robotica_clientes/pages/colaborador_form.dart';
import 'package:asia_robotica_clientes/pages/api_zoho.dart';
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
        backgroundColor: const Color(0xFF012B54),
        title: Row(
          children: [
            Image.asset(
              'lib/images/logo-asia-rob.png',
              width: 140,
            ),
            const SizedBox(width: 15),
            const Text(
              'Inicio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: cerrarSesion,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Usuario: ${user?.displayName ?? 'Desconocido'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Correo: ${user?.email ?? 'Desconocido'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ButtonTheme(
              minWidth: 200.0, // Ajusta este valor según tus necesidades
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MiFormulario()),
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
                  'Colaborador AR',
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
                    MaterialPageRoute(
                        builder: (context) => const ClientesPage(
                              title: 'Asia Robotica',
                            )),
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
                  'Cliente',
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ButtonTheme(
              minWidth: 200.0, // Ajusta este valor según tus necesidades
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ApiZohoPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: const Color.fromARGB(255, 144, 150, 65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Api zoho',
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
