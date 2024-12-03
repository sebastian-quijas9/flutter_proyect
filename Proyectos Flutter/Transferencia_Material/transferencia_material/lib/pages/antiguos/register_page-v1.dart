// ignore_for_file: unused_import

import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transferencia_material/components/my_button.dart';
import 'package:transferencia_material/components/my_textfield.dart';
import 'package:transferencia_material/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

void googleSignInFunction() {
  AuthService().signInWithGoogle();
}

class _RegisterPageState extends State<RegisterPage> {
  // textediting controller
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController celularController = TextEditingController();


  final TextEditingController paswordController = TextEditingController();

  final TextEditingController paswordconfirmController =
      TextEditingController();

// metodo de registro
  void registerUser() async {
    // círculo de carga
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // asegurarnos que las contraseñas son iguales
    if (paswordController.text != paswordconfirmController.text) {
      // mostrar circulo de carga
      Navigator.pop(context);
      // mostramos error al usuario
      displayMessageToUser("Las contraseñas no coinciden!", context);
      // si las contraseñas si coinciden
    } else {
      try {
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: paswordController.text,
        );

        // crear una base de datos de usuarios
        createUserDocument(userCredential);

        // ignore: use_build_context_synchronously
        if(context.mounted)Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // muestra circulo de carga
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // muestra mensaje de error
        // ignore: use_build_context_synchronously
        displayMessageToUser(e.code, context);
      }
    }

    // tratar de crear usuario
  }

  // creaar documentos y recolectarlos en una base de datos en firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null ) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
            'celular': celularController.text,

          });
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
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 25),
              // título
              const Text(
                "R E G I S T R O",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              // Username
              GestureDetector(
                onTap: googleSignInFunction,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 300,
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
                        'Registrarse con Google',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  )),
                  Text(
                    'O',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ))
                ],
              ),

               const SizedBox(height: 25),
              MyTextField(
                hintText: "Escribe tu nombre de usuario",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),
              // email
              MyTextField(
                hintText: "ejemplo@asiarobotica.com",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              // Conraseña
              MyTextField(
                hintText: "Ingresa contraseña",
                obscureText: true,
                controller: paswordController,
              ),
              const SizedBox(height: 10),
              // Confirmar Contraseña
              MyTextField(
                hintText: "Confirmar contraseña",
                obscureText: true,
                controller: paswordconfirmController,
              ),
              const SizedBox(height: 10),
              TextFormField(
              controller: celularController,
              decoration: InputDecoration(
                labelText: 'Escribe tu numero de celular:',
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
            ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                ],
              ),

              const SizedBox(height: 50),
              // boton de inicio
              MyButton(
                text: "Registrar",
                onTap: registerUser,
              ),

              
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿¿Ya tienes cuenta??",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text('  Ingresa aquí',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
