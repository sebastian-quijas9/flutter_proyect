import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Adminentregas extends StatefulWidget {
  const Adminentregas({Key? key}) : super(key: key);

  @override
  State<Adminentregas> createState() => _AdminentregasState();
}

class _AdminentregasState extends State<Adminentregas> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 23, 24, 0.8),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(4),
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
              const Text('Entregas'),
            ],
          ),
        ),
      ),
    );
  }
}
