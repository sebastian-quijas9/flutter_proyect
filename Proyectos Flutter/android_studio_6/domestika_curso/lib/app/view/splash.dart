import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return  const Scaffold(
     body: SafeArea(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
           children: [
           Text("prueba"),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children:   [
               Text("holaaa"),
               Text("holaaa"),
             ],
           ),
         ]
       ),
     ) ,

   );
  }
}