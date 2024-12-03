// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:text_area/text_area.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  String? dropdownEquipoValue;
  Map<String, dynamic> _actividadesJsonlistview = {};
  List<Map<String, dynamic>> _actividadeslistview = [];
  Map<String, bool> _selectedActividadeslistview = {};

  final myTextController = TextEditingController();
  var reasonValidation = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadJsonData();
    myTextController.addListener(() {
      setState(() {
        reasonValidation = myTextController.text.isEmpty;
      });
    });
  }

  Future<void> loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('lib/images/actividades.json');
    _actividadesJsonlistview = jsonDecode(jsonString);

    // Guarda todo el objeto de actividad en lugar de solo el tipo
    if (dropdownEquipoValue != null) {
      _actividadeslistview = List<Map<String, dynamic>>.from(
          _actividadesJsonlistview[dropdownEquipoValue]);
      _selectedActividadeslistview = {
        for (var v in _actividadeslistview) v['tipo']: false
      };
    }
  }

  void printselectedActividadeslistview() {
    final selected = _selectedActividadeslistview.entries
        .where((element) => element.value)
        .map((element) => element.key)
        .toList();
    print('Actividades seleccionadas: $selected');

    for (var actividad in _actividadeslistview) {
      if (selected.contains(actividad['tipo'])) {
        print('Detalles de la actividad seleccionada: $actividad');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012B54),
        title: const Text(
          'Descripcion AR',
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: formKey,
                child: TextArea(
                  borderRadius: 10,
                  borderColor: const Color(0xFFCFD6FF),
                  textEditingController: myTextController,
                  suffixIcon: Icons.attach_file_rounded,
                  onSuffixIconPressed: () => {},
                  validation: reasonValidation,
                  errorText: 'Please type a reason!',
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Actividades Realizadas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: dropdownEquipoValue,
                items: <String>['', 'Equipo_externo', 'BendWorx', 'shop']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownEquipoValue = newValue;
                  });
                  loadJsonData();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una opción';
                  }
                  return null;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _actividadeslistview.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_actividadeslistview[index]['tipo']),
                      value: _selectedActividadeslistview[
                          _actividadeslistview[index]['tipo']],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedActividadeslistview[
                              _actividadeslistview[index]['tipo']] = value!;
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: printselectedActividadeslistview,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
