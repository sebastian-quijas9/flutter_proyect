import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transferencia_material/auth/auth.dart';
import 'package:transferencia_material/auth/login_or_register.dart';
import 'package:transferencia_material/pages/home_page.dart';
import 'package:transferencia_material/pages/mis_cancelados.dart';
import 'package:transferencia_material/pages/mis_completados_parami.dart';
import 'package:transferencia_material/pages/profile_page.dart';
import 'package:transferencia_material/pages/sent_materials_page.dart';
import 'package:transferencia_material/pages/usuarios_page.dart';
import 'package:transferencia_material/theme/darkmode.dart';
import 'package:transferencia_material/theme/lightmode.dart';
import 'firebase_options.dart';
import 'pages/Whats.dart';
import 'pages/mis_completados_mios.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes:{
        '/login_register_pag': (context) => const LoginorRegister(),
        '/home_page': (context) =>  HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/sent_materials_page': (context) => SendMaterial(),
        '/usuarios_page':(context) => UsersPage(),
        '/mis_cancelados':(context) => MisCancelados(),
        '/mis_completados_para_mi': (context) => MisCompletosParaMi(),
        '/mis_completados_mios': (context) => MisCompletosMios(),
        '/whats': (context) => Whats(),

      }, 
    );
  }
}

