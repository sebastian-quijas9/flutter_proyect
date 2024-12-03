import 'package:flutter/material.dart';

class ObservacionesPage extends StatelessWidget {
  final String observaciones;
  final TextEditingController _textEditingController = TextEditingController();

  ObservacionesPage({Key? key, required this.observaciones}) : super(key: key) {
    _textEditingController.text = observaciones;
  }

  // void atras(){
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           TrabajoRealizadoPage(trabajoRealizado: 'Valor del campo'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Acción al presionar el botón de retroceso
          String inputText = observaciones;
          Navigator.pop(context, inputText);
          return true; // Permite la navegación hacia atrás
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(
                22, 23, 24, 0.8), // Cambio de color a negro
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    String inputText = _textEditingController.text;
                    Navigator.pop(context, inputText);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                        child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 24,
                    )),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Observaciones y/o Recomendaciones al Cliente',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
