import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiZohoPage extends StatefulWidget {
  const ApiZohoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ApiZohoPageState createState() => _ApiZohoPageState();
}

class _ApiZohoPageState extends State<ApiZohoPage> {
  String? dropdownValue;
  Set<String> tickets = {};
  // final String _razon_social = '';
  String _maquina = '';

  Future<List<List<String>>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzB8XlDFKIzh0LyA8V04OYqVrG0rKcSSm756zTj2opGEiacp6NGRhLWAENwyJ86892E/exec?solicitud=open_tickets'));
    final data = json.decode(response.body) as List<dynamic>;
    final dataArray = data.map<List<String>>((item) {
      final ticket = item['ticket']?.toString() ?? '';
      tickets.add(ticket);
      final empresa = item['empresa'] as String? ?? '';
      final contacto = item['contacto'] as String? ?? '';
      final correo = item['correo'] as String? ?? '';
      final productId = item['productId'] as String? ?? '';

      return [ticket, empresa, contacto, correo, productId];
    }).toList();

    return dataArray;
  }

  Future<void> cargarMaquina(productId) async {
    print(productId);
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzB8XlDFKIzh0LyA8V04OYqVrG0rKcSSm756zTj2opGEiacp6NGRhLWAENwyJ86892E/exec?productId=$productId'));
    final data = jsonDecode(response.body);
    print(data);
    var nombreMaq = data["data"]["nombreMaq"];
    _maquina = nombreMaq;
    var noSerie = data["data"]["noSerie"];
    print(noSerie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012B54),
        title: const Text(
          'Zoho API',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset(
              'lib/images/logo-asia-rob_corto.png',
              width: 140,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<List<String>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('lib/images/logo_cargando.gif'),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Ocurrió un error: ${snapshot.error}'),
            );
          } else {
            final dataArray = snapshot.data!;
            return Column(
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: tickets
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataArray
                        .where((subArray) =>
                            subArray[0] == dropdownValue ||
                            dropdownValue == null)
                        .length,
                    itemBuilder: (context, index) {
                      final subArray = dataArray
                          .where((subArray) =>
                              subArray[0] == dropdownValue ||
                              dropdownValue == null)
                          .toList()[index];

                      final values = subArray.join(', ');
                      return ListTile(
                        title: Text(
                          values,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        tileColor: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
