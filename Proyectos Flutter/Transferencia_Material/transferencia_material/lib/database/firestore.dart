
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
Esta base de datos es la que muestra los materiales enviados en la app. Se almacena en una colección que se llama materiales enviados en Firebase. 

Cada post contiene toda la información que necesita el usuario para saber qué fue lo que envió.
*/

class FirestoreDatabase{
  //  current loggedin user 
  User? user= FirebaseAuth.instance.currentUser;
  // acceder a las collecciones de los matriales enviados desde firebase
  final CollectionReference posts = FirebaseFirestore.instance.collection('Enviados');
// postear la info
  Future<void> addPost(String message){
    return posts.add({
      'email': user!.email,
      'material': message,
      'timestamp': Timestamp.now(),

    });
  }



}