import 'package:flutter/material.dart';
import 'package:text_area/text_area.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  String? _selectedLocalidadServicio;
  final List<String> actividades = ["prueba1", "prueba2", "prueba3"];
  final Map<String, bool> selectedActividades = {
    "prueba1": false,
    "prueba2": false,
    "prueba3": false,
  };
  final myTextController = TextEditingController();
  var reasonValidation = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myTextController.addListener(() {
      setState(() {
        reasonValidation = myTextController.text.isEmpty;
      });
    });
  }

  void printSelectedActividades() {
    final selected = selectedActividades.entries
        .where((element) => element.value)
        .map((element) => element.key)
        .toList();
    print('Actividades seleccionadas: $selected');
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
                  labelText: 'Localidad del Servicio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _selectedLocalidadServicio,
                items: <String>['Equipo_externo', 'BendWorx', 'shop']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocalidadServicio = newValue;
                  });
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
                  itemCount: actividades.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(actividades[index]),
                      value: selectedActividades[actividades[index]],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedActividades[actividades[index]] = value!;
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: printSelectedActividades,
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
