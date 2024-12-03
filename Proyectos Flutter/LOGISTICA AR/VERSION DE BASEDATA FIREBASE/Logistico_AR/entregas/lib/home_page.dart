import 'package:entregas/pages/incoming.dart';
import 'package:entregas/pages/Enbarque.dart';
import 'package:entregas/pages/procesoInspeccion.dart';
import 'package:entregas/pages/procesoLiberacion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:entregas/admin-gps.dart';
import 'package:entregas/pages/firma-entrega.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;
  final bool isAdmin = FirebaseAuth.instance.currentUser?.email ==
          'developer@asiarobotica.com' ||
      FirebaseAuth.instance.currentUser?.email ==
          'sebastian.quijas@asiarobotica.com' ||
      FirebaseAuth.instance.currentUser?.email ==
          'armando.delarosa@asiarobotica.com'  ||
      FirebaseAuth.instance.currentUser?.email ==
          'maria.eugenia@asiarobotica.com' ||
      FirebaseAuth.instance.currentUser?.email ==
          'antonio.hernandez@asiarobotica.com' ||
      FirebaseAuth.instance.currentUser?.email ==
          'ana.lira@asiarobotica.com' ||
      FirebaseAuth.instance.currentUser?.email ==
          'prueba@hotmail.com' ;

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
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(
                  22, 23, 24, 0.8), // Cambio de color a negro
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
                    onTap: cerrarSesion,
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
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      
                      child: Column(
                        
                        children: [
                          Image.asset(
                            'lib/images/incoming.png', // Reemplaza con la ruta de la imagen
                            width:
                                500, // Ajusta el tamaño de la imagen según tus necesidades
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Radio de borde de la tarjeta
                              ),
                             
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Incoming()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromRGBO(54, 54, 57, 0.8)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Incoming',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/images/procesosInspeccion.png', // Reemplaza con la ruta de la imagen
                            width:
                                500, // Ajusta el tamaño de la imagen según tus necesidades
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Radio de borde de la tarjeta
                              ),
                              // child: const Padding(
                              //   padding: EdgeInsets.all(16.0),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         '',
                              //         style: TextStyle(fontSize: 26),
                              //       ),
                              //       Text(
                              //         ' ',
                              //         style: TextStyle(
                              //           fontSize: 26,
                              //           color: Color.fromRGBO(255, 183, 27,
                              //               1), // Cambia el color de la letra aquí
                              //           fontWeight: FontWeight
                              //               .bold, // Aplica negrita al texto
                              //         ),
                              //       ),
                              //       Text(
                              //         '(Dobladora de metal)',
                              //         style: TextStyle(fontSize: 16),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProcesoInspeccion()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromRGBO(54, 54, 57, 0.8)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Procesos de inspeccion',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/images/procesoliberacion.png', // Reemplaza con la ruta de la imagen
                            width:
                                500, // Ajusta el tamaño de la imagen según tus necesidades
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Radio de borde de la tarjeta
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProcesoLiberacion()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromRGBO(54, 54, 57, 0.8)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Procesos de liberacion',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                   Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/images/embarques.png', 
                            width:
                                500, // Ajusta el tamaño de la imagen según tus necesidades
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Radio de borde de la tarjeta
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Embarque()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromRGBO(54, 54, 57, 0.8)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Pre-Embarque',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ), Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/images/Detalles1.png', // Reemplaza con la ruta de la imagen
                            width:
                                500, // Ajusta el tamaño de la imagen según tus necesidades
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Radio de borde de la tarjeta
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Firmaentregas()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromRGBO(54, 54, 57, 0.8)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Entrega Equipos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    if (isAdmin)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/images/listado.png', // Reemplaza con la ruta de la imagen
                            width:
                                400, // Ajusta el tamaño de la imagen según tus necesidades
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Radio de borde de la tarjeta
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Adminentregas()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromRGBO(54, 54, 57, 0.8)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Listado de entregas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
