import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MiFormulario extends StatefulWidget {
  const MiFormulario({Key? key}) : super(key: key);

  @override
  MiFormularioState createState() {
    return MiFormularioState();
  }
}

class MiFormularioState extends State<MiFormulario> {
  String? dropdownValue;
  String? dropdownValue1;
  Map<String, List<String>> ticketsData = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _currentUltimaHoja;
  String? _currentCausaRaiz;
  String? _currentEspecificarFallaManoDeObra;
  String? _currentEspecificarFallaMaquina;
  String? _currentEspecificarFallaMaterial;
  String? _currentEspecificarFallaMantenimiento;
  String? _currentEspecificarFallaInstalacion;
  String usuario = 'Desconocido';
  String correo = 'Desconocido';
  Map<String, dynamic> maquinas = {};
  String? dropdownFamiliaValue;
  String? dropdownEquipoValue;
  String? _selectedLocalidadServicio;
  var reasonValidation = true;
  bool primeraVez = false;
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isActived = false;
  bool guardandoDatos = false;
  final _formKey = GlobalKey<FormState>();
  DateTime? _fechaSeleccionada;
  List<dynamic> actividades = [];
  final _dateFormat = DateFormat('dd-MM-yyyy');
  final _dateController = TextEditingController();
  String? _opcionSeleccionable = "";
  final _ticketController = TextEditingController();
  List<String> selectedActividades = [];
  Map<String, dynamic> _actividadesJsonlistview = {};
  List<Map<String, dynamic>> _actividadeslistview = [];
  Map<String, bool> _selectedActividadeslistview = {};
  final _razonSocialController = TextEditingController();
  final _contactoController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _modeloController = TextEditingController();
  final _noSerieController = TextEditingController();
  final _tipoServicioController = TextEditingController();
  final _motivoServicioController = TextEditingController();
  final _localidadController = TextEditingController();
  final _ultimaHojaController = TextEditingController();
  final _horaLlegadaController = TextEditingController();
  final _horaSalidaController = TextEditingController();
  final _horaLlegadaaController = TextEditingController();
  final _comidaController = TextEditingController();
  final _familiaController = TextEditingController();
  final _equipoController = TextEditingController();
  final _hojasservicioController = TextEditingController();
  final _especificarFallaController = TextEditingController();
  final _causaRaizController = TextEditingController();
  final _clasificacionFallaController = TextEditingController();
  final _trabajoRealizadoController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _timeFormat = DateFormat('hh:mm a');

  Set<String> tickets = {};

  void cargarMaquinas() async {
    String maquinasJson =
        await rootBundle.loadString('lib/images/maquinas.json');
    maquinas = json.decode(maquinasJson);
  }

  void getUserData() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      if (user.displayName != null) {
        setState(() {
          usuario = user.displayName!;
        });
      }

      if (user.email != null) {
        setState(() {
          correo = user.email!;
        });
      }
    }
  }

  List<String> getDropdownItems() {
    if (_currentEspecificarFallaManoDeObra ==
            "Componente o accesorio de apoyo fuera de especificación" ||
        _currentEspecificarFallaMaquina ==
            "Componente o accesorio de apoyo fuera de especificación" ||
        _currentEspecificarFallaMaterial ==
            "Componente o accesorio de apoyo fuera de especificación" ||
        _currentEspecificarFallaMantenimiento ==
            "Componente o accesorio de apoyo fuera de especificación" ||
        _currentEspecificarFallaInstalacion ==
            "Componente o accesorio de apoyo fuera de especificación") {
      return [
        "",
        "Chiller",
        "Sistema de extracción",
        "Sistema SAAP (Incluido en el equipo)",
        "Fuente de alimentación de aire (Propiedad del cliente)"
      ];
    } else if (_currentEspecificarFallaManoDeObra ==
            "Método (Uso de la máquina)" ||
        _currentEspecificarFallaMaquina == "Método (Uso de la máquina)" ||
        _currentEspecificarFallaMaterial == "Método (Uso de la máquina)" ||
        _currentEspecificarFallaMantenimiento == "Método (Uso de la máquina)" ||
        _currentEspecificarFallaInstalacion == "Método (Uso de la máquina)") {
      return [
        "",
        "Uso inadecuado de la máquina",
        "Uso de herramienta de corte inadecuada"
      ];
    } else {
      return [];
    }
  }

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
      ticketsData[ticket] = [empresa, contacto, correo, productId];
      return [ticket, empresa, contacto, correo, productId];
    }).toList();

    return dataArray;
  }

  Future<void> cargarMaquina(productId) async {
    _modeloController.text = "";
    _noSerieController.text = "";
    print(productId);
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzB8XlDFKIzh0LyA8V04OYqVrG0rKcSSm756zTj2opGEiacp6NGRhLWAENwyJ86892E/exec?productId=$productId'));
    final data = jsonDecode(response.body);
    print(data);
    var nombreMaq = data["data"]["nombreMaq"];
    print(nombreMaq);
    var noSerie = data["data"]["noSerie"];
    print(noSerie);
    _modeloController.text = nombreMaq;
    _noSerieController.text = noSerie;
  }

  final List<String> _tipoServicioList = [
    "",
    'Garantia',
    'Servicio Pagado',
    'Instalaciones y capacitacion',
    'Por Definir'
  ];
  String? _currentTipoServicio;
  String? _currentMotivoServicio;

  final Map<String, List<String>> _motivoServicioOptions = {
    'Garantia': [
      "",
      'Instalación de Refacción',
      'Diagnóstico',
      'Envío a Taller'
    ],
    'Servicio Pagado': [
      "",
      'Instalación de Refacción',
      'Envío a Taller',
      'Diagnóstico',
      'Capacitación',
      'Reubicación de Equipo',
      'Mantenimiento Preventivo',
      'Mantenimiento Correctivo',
    ],
    'Instalaciones y capacitacion': [
      "",
      'Instalación de Equipo',
      'Capacitación'
    ],
    'Por Definir': [
      "",
      "Instalación de Refacción",
      "Diagnóstico",
      "Envío a Taller",
      "Reubicación de Equipo",
      "Mantenimiento Preventivo",
      "Mantenimiento Correctivo"
    ],
  };

  final List<String> _clasificacionFallaList = [
    "",
    "Mano de obra (Operador)",
    "Máquina (Equipo AR)",
    "Material (Materiales procesados en el equipo)",
    "Mantenimiento (Falta de mantenimiento)",
    "Instalación fuera de estándar (Medio ambiente)",
  ];

  Future<void> loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('lib/images/actividades.json');
    Map<String, dynamic> map = jsonDecode(jsonString);

    map.forEach((key, value) {
      print('Key: $key');
      List<dynamic> lista = value;
      lista.forEach((item) {
        print('Id: ${item['id']}');
        print('No_dias: ${item['no_dias']}');
        print('Tiempo: ${item['tiempo']}');
        print('Tipo: ${item['tipo']}');
        print('----');
      });
    });
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Formulario válido, realiza la acción deseada
      _formKey.currentState!.save();
      setState(() {
        guardandoDatos = true;
      });
      String fechaServicio = _dateController.text;
      String razonSocial = _razonSocialController.text;
      String contacto = _contactoController.text;
      String correoCliente = _correoController.text;
      String numeroCliente = _telefonoController.text;
      String maquina = _modeloController.text;
      String noSerie = _noSerieController.text;
      String horaComida = _comidaController.text;
      String trabajoRealizado = _trabajoRealizadoController.text;
      String observaciones = _observacionesController.text;
      String horallegada = _horaLlegadaController.text;
      String horasalida = _horaSalidaController.text;
      String _currentEspecificarFallaInstalacion = "";

      if (_currentCausaRaiz == "Mano de obra (Operador)") {
        if (_currentEspecificarFallaManoDeObra != null) {
          _currentEspecificarFallaInstalacion;
        }
      } else if (_currentCausaRaiz == "Máquina (Equipo AR)") {
        if (_currentEspecificarFallaMaquina != null) {
          _currentEspecificarFallaInstalacion;
        }
      } else if (_currentCausaRaiz ==
          "Material (Materiales procesados en el equipo)") {
        if (_currentEspecificarFallaMaterial != null) {
          _currentEspecificarFallaInstalacion;
        }
      } else if (_currentCausaRaiz ==
          "Mantenimiento (Falta de mantenimiento)") {
        if (_currentEspecificarFallaMantenimiento != null) {
          _currentEspecificarFallaInstalacion;
        }
      } else if (_currentCausaRaiz ==
          "Instalación fuera de estándar (Medio ambiente)") {
        if (_currentEspecificarFallaInstalacion != null) {
          _currentEspecificarFallaInstalacion;
        }
      }

      print('Fecha: $fechaServicio');
      print('Razon Social: $razonSocial');
      print('Contacto: $contacto');
      print('Correo: $correoCliente');
      print('Número de Tel: $numeroCliente');
      print('Maquina: $maquina');
      print('No Serie: $noSerie');
      print('Tipo de Servicio: $_currentTipoServicio');
      print('Motivo del Servicio: $_currentMotivoServicio');
      print('Localidad del Servicio: $_selectedLocalidadServicio');
      print('Ultima Hoja: $_currentUltimaHoja');
      print('Hora de Llegada: $horallegada');
      print('Hora de Salida: $horasalida');
      print('Hora de Comida: $horaComida');
      print('Familia: $dropdownFamiliaValue');
      print('Modelo: $dropdownEquipoValue');
      print('Clasificación de Falla: $_currentCausaRaiz');
      print('Causa Raíz: $_currentEspecificarFallaInstalacion');
      print('Especificar la Falla: $_opcionSeleccionable');
      print('Trabajo Realizado: $trabajoRealizado');
      print('Observaciones: $observaciones');

      String timeString = horaComida;
      String hours = "00";
      String minutes = "00";

      List<String> parts = timeString.split(':');
      if (parts.length == 2) {
        hours = parts[0];
        minutes = parts[1];

        print('Hours: $hours');
        print('Minutes: $minutes');
      } else {
        print('Invalid time format');
      }

      // Crear el mapa con los datos
      final jsonData = {
        'nombre_tecnico': usuario,
        'email_tecnico': correo,
        'fecha': '${fechaServicio}T12:00:00.000Z',
        "ticket": '$dropdownValue',
        'razon_social': razonSocial,
        'contacto_empresa': contacto,
        'correo_cliente': correoCliente,
        'telefono_cliente': numeroCliente,
        'no_proporciono_telefono': _isActived,
        'modelo': maquina,
        'no_serie': noSerie,
        'tipo_servicio': _currentTipoServicio,
        'motivo_servicio': _currentMotivoServicio,
        'localidad_servicio': _selectedLocalidadServicio,
        'ultima_hoja': _currentUltimaHoja,
        'hora_llegada': horallegada,
        'hora_salida': horasalida,
        'horas': hours,
        'minutos': minutes,
        'familia_eq': dropdownFamiliaValue,
        'equipo': dropdownEquipoValue,
        'clasificacion_falla': _currentCausaRaiz,
        'causa_raiz': _currentEspecificarFallaInstalacion,
        'especificar_falla': _opcionSeleccionable,
        'actividades_realizadas': trabajoRealizado,
        'observaciones': observaciones,
        'tiempo_comida': horaComida,
        'id_carpeta': "1pjtA-Mu2gVZqPbGmYMMNOTtUskl7trVZ"
      };

      // Convertir el mapa a una cadena JSON
      final jsonString = json.encode(jsonData);

      print(jsonString);

      // Codificar la cadena JSON en Base64
      final bytes = utf8.encode(jsonString);
      final base64String = base64.encode(bytes);

      print(base64String);

      String url =
          'https://script.google.com/macros/s/AKfycbw6LBaegyigQSTwKprr52wmyosCC-CRqImwPaifmuXRoKcrA-Fh8eHBcmS5YtCgZ7UPGw/exec';
      String api = '${url}?guardar=${base64String}';

      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];

        if (contentType != null && contentType.contains('application/json')) {
          final jsonResponse = json.decode(response.body);
          print(jsonResponse);
          if (jsonResponse["result"] == "success") {
            setState(() {
              guardandoDatos = false;
            });
          }
        } else {
          print('Invalid JSON response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    cargarMaquinas();

    fetchData().then((dataArray) {
      setState(() {
        dropdownValue = tickets.first;
      });
    });
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<String>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            primeraVez == false) {
          primeraVez = true;
          return Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset('lib/images/logo_cargando.gif'),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return buildScaffold();
        }
      },
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012B54),
        title: const Text(
          'Hoja de Servicio',
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Usuario: $usuario",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Correo: $correo",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    final fecha = await showDatePicker(
                      context: context,
                      initialDate: _fechaSeleccionada ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (fecha != null) {
                      setState(() {
                        _fechaSeleccionada = fecha;
                        _dateController.text = _dateFormat.format(fecha);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Día del Servicio',
                        labelStyle: GoogleFonts.roboto(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingrese la fecha';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          if (dropdownValue != null &&
                              ticketsData.containsKey(dropdownValue)) {
                            _razonSocialController.text =
                                ticketsData[dropdownValue!]![0];
                            _contactoController.text =
                                ticketsData[dropdownValue!]![1];
                            _correoController.text =
                                ticketsData[dropdownValue!]![2];
                            _horaLlegadaaController.text =
                                ticketsData[dropdownValue!]![3];
                            var productId = ticketsData[dropdownValue!]![3];
                            cargarMaquina(productId);
                          }
                        });
                      },
                      items: tickets
                          .toList()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      underline: Container(
                        height: 2,
                        color: const Color(0xFF012B54),
                      ),
                      isExpanded: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _razonSocialController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Razon Social',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: _contactoController,
                  decoration: InputDecoration(
                    labelText: 'Contacto de la Empresa',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: 'Correo del Cliente',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _telefonoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Teléfono del Cliente (a 10 dígitos)',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  enabled: !_isActived,
                ),
                CheckboxListTile(
                  value: _isActived,
                  onChanged: (bool? valueIn) {
                    setState(() {
                      _isActived = valueIn!;
                      if (_isActived) {
                        _telefonoController.text = "";
                      }
                    });
                  },
                  title: const Text("El cliente no proporcionó su teléfono"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: _modeloController,
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: _noSerieController,
                  decoration: InputDecoration(
                    labelText: 'No Serie',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Tipo de Servicio',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _currentTipoServicio,
                  items: _tipoServicioList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentTipoServicio = newValue;
                      _currentMotivoServicio = "";
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un tipo de servicio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Motivo del Servicio',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _currentMotivoServicio,
                  items: (_motivoServicioOptions[_currentTipoServicio] ?? [])
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentMotivoServicio = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Localidad del Servicio',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _selectedLocalidadServicio,
                  items: <String>['Local', 'Foráneo']
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
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '¿Última Hoja?',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _currentUltimaHoja,
                  items: <String>['Si', 'No', 'Servicio Pendiente (si aplica)']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentUltimaHoja = newValue;
                      if (_currentUltimaHoja != 'Si') {
                        _currentCausaRaiz =
                            null; // Reinicia el valor de Causa Raíz cuando "¿Última Hoja?" no es "Si"
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione una opción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _horaLlegadaController,
                  decoration: InputDecoration(
                    labelText: 'Hora de Llegada',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese algún texto';
                    }
                    return null;
                  },
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _horaLlegadaController.text = _timeFormat
                            .format(DateTime(1, 1, 1, time.hour, time.minute));
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _horaSalidaController,
                  decoration: InputDecoration(
                    labelText: 'Hora de Salida',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese algún texto';
                    }
                    return null;
                  },
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _horaSalidaController.text = _timeFormat
                            .format(DateTime(1, 1, 1, time.hour, time.minute));
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _comidaController,
                  decoration: InputDecoration(
                    labelText: 'Tiempo de comida (hrs)',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese algún texto';
                    }
                    return null;
                  },
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 1, minute: 00),
                      initialEntryMode: TimePickerEntryMode.input,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      setState(() {
                        _comidaController.text =
                            '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                _currentUltimaHoja == 'Si'
                    ? TextFormField(
                        controller: _hojasservicioController,
                        decoration: InputDecoration(
                          labelText: '¿Cuantas hojas de servicio llenaste?',
                          labelStyle: GoogleFonts.roboto(fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      )
                    : Container(),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: dropdownFamiliaValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownFamiliaValue = newValue;
                      dropdownEquipoValue = null; // Resetea el valor del equipo
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Familia',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items:
                      maquinas["equipos"].map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item["familia"],
                      child: Text(item["familia"]),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: dropdownEquipoValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownEquipoValue = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Equipo',
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: dropdownFamiliaValue == null
                      ? []
                      : maquinas["equipos"]
                          .firstWhere((item) =>
                              item["familia"] ==
                              dropdownFamiliaValue)["maquinas"]
                          .map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                ),
                // Container(
                //   height: 200, // Ajusta este valor según lo que necesites
                //   child: FutureBuilder(
                //     future: loadJsonData(),
                //     builder: (BuildContext context,
                //         AsyncSnapshot<Map<String, dynamic>> snapshot) {
                //       if (snapshot.hasData) {
                //         if (dropdownEquipoValue != null &&
                //             snapshot.data!.containsKey(dropdownEquipoValue)) {
                //           return ListView.builder(
                //             itemCount:
                //                 snapshot.data![dropdownEquipoValue].length,
                //             itemBuilder: (BuildContext context, int index) {
                //               return ListTile(
                //                 title: Text(snapshot.data![dropdownEquipoValue]
                //                     [index]['tipo']),
                //               );
                //             },
                //           );
                //         } else {
                //           return Text("No se encontró el equipo seleccionado");
                //         }
                //       } else if (snapshot.hasError) {
                //         return Text("Ocurrió un error al cargar los datos");
                //       } else {
                //         return CircularProgressIndicator();
                //       }
                //     },
                //   ),
                // ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Actividades Realizadas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: <String>["prueba1", "prueba2", "prueba3"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      // Cuando se selecciona una nueva opción, se añade a la lista
                      selectedActividades.add(newValue!);
                    });
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedActividades.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(selectedActividades[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            selectedActividades.removeAt(index);
                            for (var actividad in selectedActividades) {
                              print(actividad);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (_currentUltimaHoja == 'Si' &&
                    (_currentMotivoServicio == 'Instalación de Refacción' ||
                        _currentMotivoServicio == 'Diagnóstico' ||
                        _currentMotivoServicio == 'Mantenimiento Correctivo'))
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Clasificación de Falla',
                          labelStyle: GoogleFonts.roboto(fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: _currentUltimaHoja == 'Si'
                            ? _currentCausaRaiz
                            : null,
                        items: <String>[
                          "",
                          "Mano de obra (Operador)",
                          "Máquina (Equipo AR)",
                          "Material (Materiales procesados en el equipo)",
                          "Mantenimiento (Falta de mantenimiento)",
                          "Instalación fuera de estándar (Medio ambiente)"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _currentCausaRaiz = newValue;
                            _currentEspecificarFallaManoDeObra = "";
                            _currentEspecificarFallaMaquina = "";
                            _currentEspecificarFallaMaterial = "";
                            _currentEspecificarFallaMantenimiento = "";
                            _currentEspecificarFallaInstalacion = "";
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona una causa raíz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_currentCausaRaiz == "Mano de obra (Operador)")
                        Container(
                          width: double.infinity, // Ancho máximo disponible
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Causa Raíz',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _currentEspecificarFallaManoDeObra,
                            items: <String>[
                              "",
                              "Operador no capacitado",
                              "Operador no calificado",
                              "Error de operación",
                              "Uso de máquina con parámetros fuera de rango de especificación"
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize:
                                          13), // Tamaño de fuente más pequeño
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentEspecificarFallaManoDeObra = newValue;
                                _opcionSeleccionable = "";
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona una opción';
                              }
                              return null;
                            },
                          ),
                        ),
                      if (_currentCausaRaiz == "Máquina (Equipo AR)")
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Causa Raíz',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _currentEspecificarFallaMaquina,
                          items: <String>[
                            "",
                            "Desgaste",
                            "Cumplió su vida útil",
                            "Defecto de fabricación",
                            "Componente defectuoso de proveedor (China)",
                            "La especificación de la máquina no es adecuada al proceso del cliente",
                            "Componente o accesorio de apoyo fuera de especificación"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontSize:
                                        12), // Tamaño de fuente más pequeño
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentEspecificarFallaMaquina = newValue;
                              _opcionSeleccionable = "";
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor selecciona una opción';
                            }
                            return null;
                          },
                        ),
                      if (_currentCausaRaiz ==
                          "Material (Materiales procesados en el equipo)")
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Causa Raíz',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _currentEspecificarFallaMaterial,
                          items: <String>[
                            "",
                            "La especificación del material no es acorde a la especificación de la máquina",
                            "Método (Uso de la máquina)"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontSize:
                                        12), // Tamaño de fuente más pequeño
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentEspecificarFallaMaterial = newValue;
                              _opcionSeleccionable = "";
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor selecciona una opción';
                            }
                            return null;
                          },
                        ),
                      if (_currentCausaRaiz ==
                          "Mantenimiento (Falta de mantenimiento)")
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Causa Raíz',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _currentEspecificarFallaMantenimiento,
                          items: <String>[
                            "",
                            "Falta de mantenimiento preventivo",
                            "Daño por mantenimiento por personal no calificado",
                            "Uso del equipo bajo condiciones no aptas",
                            "Uso de componente o accesorio de apoyo con falla"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontSize:
                                        12), // Tamaño de fuente más pequeño
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentEspecificarFallaMantenimiento = newValue;
                              _opcionSeleccionable = "";
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor selecciona una opción';
                            }
                            return null;
                          },
                        ),
                      if (_currentCausaRaiz ==
                          "Instalación fuera de estándar (Medio ambiente)")
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Causa Raíz',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _currentEspecificarFallaInstalacion,
                          items: <String>[
                            "",
                            "Piso desnivelado",
                            "Máquina instalada en Área abierta",
                            "Exceso de suciedad",
                            "Área no ventilada",
                            "Alimentación eléctrica fuera de estándar",
                            "Cable de alimentación fuera de especificación",
                            "Equipo no aterrizado"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontSize:
                                        12), // Tamaño de fuente más pequeño
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentEspecificarFallaInstalacion = newValue;
                              _opcionSeleccionable = "";
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor selecciona una opción';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                if (getDropdownItems().isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Especificar la Falla (si aplica)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: _opcionSeleccionable,
                        items: getDropdownItems()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 12, // Tamaño de fuente más pequeño
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _opcionSeleccionable = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona una opción';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _trabajoRealizadoController,
                  decoration: InputDecoration(
                    labelText: 'Trabajo Realizado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese algún texto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _observacionesController,
                  decoration: InputDecoration(
                    labelText: 'Observaciones y/o Recomendaciones al Cliente',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese algún texto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // _submitForm();
                        loadJsonData();
                        // printselectedActividadeslistview();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF012B54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Enviar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
