import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transferencia_material/auth/login_or_register.dart';
import 'package:transferencia_material/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance. authStateChanges(),
        builder: (context, snapshot){
          // si el usuario está loggeado
          if (snapshot.hasData){
            return HomePage();
          }
          else{
            return const LoginorRegister();

          }
          

          // si el usuario no está loggeado
        },
      ),
    );
  }
}