import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // funcion para logearse
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // drawer header
          Column(
            children: [
              const Image(
                image: AssetImage('lib/images/AR_LOGO.png'),
                width: 200,
                height: 200,
              ),

              const SizedBox(height: 25),

              // home tile (pagina de bandeja de entrada)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(Icons.mail),
                  title: const Text('Bandeja de entrada'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // profile tile (pagina de tu perfil)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(Icons.send_to_mobile_outlined),
                  title: const Text('Enviar Material'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/sent_materials_page');
                  },
                ),
              ),
              //----------------------------------PRUEBA-----------------------------
              // Padding(
              //   padding: const EdgeInsets.only(left: 15.0),
              //   child: ListTile(
              //     leading: const Icon(Icons.send_to_mobile_outlined),
              //     title: const Text('W h a t s'),
              //     onTap: () {
              //       Navigator.pop(context);
              //       Navigator.pushNamed(context, '/whats');
              //     },
              //   ),
              // ),
                //----------------------------------PRUEBA-----------------------------
              //Mis enviados
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ExpansionTile(
                  leading: const Icon(Icons.check_circle_sharp),
                  title: const Text('Completados'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.chevron_right),
                      title: const Text('Entrantes'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/mis_completados_mios');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.chevron_left),
                      title: const Text('Salientes'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, '/mis_completados_para_mi');
                      },
                    ),
                  ],
                ),
              ),

              //Mis cancelados
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Mis Cancelados'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/mis_cancelados');
                  },
                ),
              ),
              // users tile (pagina de los usuarios)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: const Text('Tu perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Usuarios'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/usuarios_page');
                  },
                ),
              ),
            ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Salir. . .'),
              onTap: () {
                Navigator.pop(context);

                logout();
              },
            ),
          )
        ],
      ),
    );
  }
}
