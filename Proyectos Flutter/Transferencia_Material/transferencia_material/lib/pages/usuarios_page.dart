import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transferencia_material/components/my_back_button.dart';
import 'package:transferencia_material/helper/helper_functions.dart';

// ignore: camel_case_types
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("usuarios").snapshots(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError){
            displayMessageToUser("Something went wrong", context);
          }
          // círculo de carga

          if (snapshot.connectionState== ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.data == null){
            return const Text("Sin datos");
          }
          // todos los usuarios
          final users = snapshot.data!.docs;

          return Column(
            children: [
                                const Padding(
                    padding: EdgeInsets.only(
                      top: 50,
                      left: 25,
                    ),
                    child: Row(
                      children: [
                        MyBackButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),


              //  listado de usuarios en la app
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding:const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final user= users[index];
              
                    return ListTile(
                      title: Text(user['nombre']),
                      subtitle: Text(user['correo']),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}