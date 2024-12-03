// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/components/my_button.dart';
// import 'package:flutter_application_1/components/my_textfield.dart';
import 'package:transferencia_material/helper/helper_functions.dart';

import 'services/auth_service.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

void googleSignInFunction() async {
    UserCredential? userCredential = await AuthService().signInWithGoogle();

    if (userCredential != null && userCredential.user != null) {
      final String userEmail = userCredential.user!.email ?? "";

      final existingUser = await FirebaseFirestore.instance
          .collection("usuarios")
          .where('correo', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        print("El usuario existe en la base de datos");
      } else {
        print("El usuario no existe en la base de datos");
        await FirebaseAuth.instance.signOut();
      }
    }
  }

class _LoginPageState extends State<LoginPage> {
  // textediting controller
  final TextEditingController emailController = TextEditingController();

  final TextEditingController paswordController = TextEditingController();

  void login() async {
    // muestra circulo de carga
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // tratar de ingresar
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: paswordController.text);

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('lib/images/LOGO_ASIAROBOTICA.png'),
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 15),
              // título
              const Text(
                "TRANSFERENCIAS",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 50),
              // email
              GestureDetector(
                onTap: googleSignInFunction,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(24),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          'lib/images/google.png',
                          height: 32,
                        ),
                      ),
                      const Text(
                        'Entrar con Google',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(
              //         child: Divider(
              //       thickness: 0.5,
              //       color: Colors.grey[400],
              //     )),
              //     Text(
              //       'O',
              //       style: TextStyle(color: Colors.grey[700]),
              //     ),
              //     Expanded(
              //         child: Divider(
              //       thickness: 0.5,
              //       color: Colors.grey[400],
              //     ))
              //   ],
              // ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "¿¿No tienes cuenta??",
                  //   style: TextStyle(
                  //       color: Theme.of(context).colorScheme.inversePrimary),
                  // ),
                  // GestureDetector(
                  //   onTap: widget.onTap,
                  //   child: const Text('  Registrate aquí',
                  //       style: TextStyle(fontWeight: FontWeight.bold)),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
