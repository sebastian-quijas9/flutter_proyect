import 'package:app_clientes/observaciones.dart';
import 'package:app_clientes/trabajo_realizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class Clientes extends StatefulWidget {
  const Clientes({Key? key}) : super(key: key);

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final user = FirebaseAuth.instance.currentUser!;

  final _formKey = GlobalKey<FormState>();

  List data = [];
  // Initial Selected Value
  String? dropdownValue = '------------ ticket ------------';
  // List of items in our dropdown menu
  Set<String> tickets = {};
  //Bandera solo una vez
  bool primeraVez = false;
  bool guardandoDatos = false;

  late DateTime? selectedDate;
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('hh:mm a');
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _horaLlegadaController = TextEditingController();
  final TextEditingController _horaSalidaController = TextEditingController();
  Map<String, dynamic> maquinas = {};
  Map<String, dynamic> actividades = {};

  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _contactoController = TextEditingController();
  final TextEditingController _correoClienteController =
      TextEditingController();
  final TextEditingController _numeroClienteController =
      TextEditingController();
  final TextEditingController _maquinaController = TextEditingController();
  final TextEditingController _noSerieController = TextEditingController();
  final TextEditingController _horaComidaController = TextEditingController();
  final TextEditingController _hojasServicioController =
      TextEditingController();
  final TextEditingController _trabajoRealizadoController =
      TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();

  String _selectedTipoServicio =
      '------------ servicio ------------'; // Valor inicial seleccionado

  final List<String> _tiposServicio = [
    '------------ servicio ------------',
    'Garantía',
    'Servicio Pagado',
    'Instalación y Capacitación',
    'Por Definir',
  ];

  String _selectedLocalidadServicio =
      '------------ localidad ------------'; // Valor inicial seleccionado

  final List<String> _localidadesServicio = [
    '------------ localidad ------------',
    'Local',
    'Foráneo',
  ];

  String _selectedUltimaHoja =
      '---------- ultima hoja ----------'; // Valor inicial seleccionado

  final List<String> _ultimaHoja = [
    '---------- ultima hoja ----------',
    'Sí',
    'No',
    'Servicio Pendiente',
  ];

  String? _selectedFamilia =
      '------------ familia ------------'; // Valor inicial seleccionado

  final List<String> _familiasEq = [
    '------------ familia ------------',
    'Router',
    'Láser CO2',
    'Láser Fibra Óptica',
    'Plasma',
    'Externo',
  ];

  String? _selectedEquipo =
      '------------ equipo ------------'; // Valor inicial seleccionado

  final List<String> _equipo = [
    '------------ equipo ------------',
  ];

  String? _selectedMotivo =
      '------------ motivo ------------'; // Valor inicial seleccionado

  late List<String> _motivoServicio = [
    '------------ motivo ------------',
  ];

  String? _selectedClasificacion =
      '---------- clasificacion ----------'; // Valor inicial seleccionado

  late List<String> _clasificacionFalla = [
    '---------- clasificacion ----------',
  ];

  String? _selectedCausaRaiz =
      '---------- causa raiz ----------'; // Valor inicial seleccionado

  late List<String> _causaRaiz = [
    '---------- causa raiz ----------',
  ];

  String? _selectedEspecificarFalla =
      '--------- especificar falla ---------'; // Valor inicial seleccionado

  late List<String> _especificarFalla = [
    '--------- especificar falla ---------',
  ];

  List<String> selectedTags = [];

  List<String> availableTags = [];

  List<String> tipos = [];

  List<String> tiemposAct = [];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Formulario válido, realiza la acción deseada
      _formKey.currentState!.save();
      setState(() {
        guardandoDatos = true;
      });
      final formattedDate = dateFormatter.format(selectedDate!);
      final formattedDateLlegada = _horaLlegadaController.text;
      final formattedDateSalida = _horaSalidaController.text;

      String razonSocial = _razonSocialController.text;
      String contacto = _contactoController.text;
      String correoCliente = _correoClienteController.text;
      String numeroCliente = _numeroClienteController.text;
      String maquina = _maquinaController.text;
      String noSerie = _noSerieController.text;
      String horaComida = _horaComidaController.text;
      String noHojas = _hojasServicioController.text;
      String trabajoRealizado = _trabajoRealizadoController.text;
      String observaciones = _observacionesController.text;

      String tagsString = selectedTags.join(', ');

      print('Fecha: $formattedDate');
      print('Razon Social: $razonSocial');
      print('Contacto: $contacto');
      print('Correo: $correoCliente');
      print('Número de Tel: $numeroCliente');
      print('Maquina: $maquina');
      print('No Serie: $noSerie');
      print('Tipo de Servicio: $_selectedTipoServicio');
      print('Motivo del Servicio: $_selectedMotivo');
      print('Localidad del Servicio: $_selectedLocalidadServicio');
      print('Ultima Hoja: $_selectedUltimaHoja');
      print('Hora de Llegada: $formattedDateLlegada');
      print('Hora de Salida: $formattedDateSalida');
      print('Hora de Comida: $horaComida');
      print('Número de Hojas: $noHojas');
      print('Familia: $_selectedFamilia');
      print('Modelo: $_selectedEquipo');
      print('Clasificación de Falla: $_selectedClasificacion');
      print('Causa Raíz: $_selectedCausaRaiz');
      print('Especificar la Falla: $_selectedEspecificarFalla');
      print('Trabajo Realizado: $trabajoRealizado');
      print('Observaciones: $observaciones');
      print('Actividades: $tagsString');

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

      List<String> registroTiempos = [];

      for (String tag in selectedTags) {
        int index = tipos.indexOf(tag);
        if (index != -1) {
          registroTiempos.add(tiemposAct[index].toString());
        }
      }

      print(registroTiempos);

      int sumaTiempos = 0;
      for (String tiempo in registroTiempos) {
        sumaTiempos += int.parse(tiempo);
      }

      String tiempoTotal = sumaTiempos.toString();

      print('Tiempo total: $tiempoTotal');

      // Crear el mapa con los datos
      final jsonData = {
        'nombre_tecnico': user.displayName,
        'email_tecnico': user.email,
        'fecha': '${formattedDate}T12:00:00.000Z',
        "ticket": '$dropdownValue',
        'razon_social': razonSocial,
        'contacto_empresa': contacto,
        'correo_cliente': correoCliente,
        'telefono_cliente': numeroCliente,
        'no_proporciono_telefono': false,
        'modelo': maquina,
        'no_serie': noSerie,
        'tipo_servicio': _selectedTipoServicio,
        'motivo_servicio': _selectedMotivo,
        'localidad_servicio': _selectedLocalidadServicio,
        'ultima_hoja': _selectedUltimaHoja,
        'hora_llegada': formattedDateLlegada,
        'hora_salida': formattedDateSalida,
        'horas': hours,
        'minutos': minutes,
        'familia_eq': _selectedFamilia,
        'equipo': _selectedEquipo,
        'clasificacion_falla': _selectedClasificacion,
        'causa_raiz': _selectedCausaRaiz,
        'especificar_falla': _selectedEspecificarFalla,
        'actividades_realizadas': trabajoRealizado,
        'observaciones': observaciones,
        'tiempo_comida': horaComida,
        'actividades': tagsString,
        'tiempo_actividades': tiempoTotal,
        'no_hojas': noHojas,
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
      String api = '$url?guardar=$base64String';

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

  void updateRazonSocial(String ticket) {
    if (ticket != '------------ ticket ------------') {
      print(ticket);
      final ticketData = data.firstWhere(
        (item) => item[0] == ticket,
        orElse: () => ['', '', '', '', ''],
      );

      var productId = ticketData.length > 4 ? ticketData[4] : '';
      print(ticketData[1]);
      cargarMaquina(productId, ticketData);
    } else {
      _razonSocialController.text = "";
      _contactoController.text = "";
      _correoClienteController.text = "";
      _maquinaController.text = "";
      _noSerieController.text = "";
      _horaComidaController.text = "";
      _trabajoRealizadoController.text = "";
      _observacionesController.text = "";
    }
    setState(() {});
  }

  void updateEquipos(String familia) async {
    if (familia != '------------ familia ------------') {
      print(familia);
      String maquinasJson =
          await rootBundle.loadString('lib/images/maquinas.json');
      maquinas = json.decode(maquinasJson);
      print(maquinas);
      final equipos = maquinas['equipos'] as List<dynamic>;

      // Buscar el array de máquinas correspondiente a la familia seleccionada
      final maquinasFamilia = equipos.firstWhere(
          (equipo) => equipo['familia'] == familia,
          orElse: () => null);

      if (maquinasFamilia != null) {
        final maquinasList = maquinasFamilia['maquinas'] as List<dynamic>?;

        if (maquinasList != null) {
          _equipo.clear(); // Limpiar la lista de modelos
          _equipo
              .add('------------ equipo ------------'); // Agregar valor inicial
          _equipo.addAll(maquinasList.cast<String>()); // Agregar nuevos modelos
          setState(() {
            _selectedEquipo = _equipo.first; // Actualizar el valor seleccionado
          });
          print(_equipo);
        } else {
          print('No se encontraron máquinas para la familia seleccionada');
        }
      }
    } else {
      print("La familia seleccionada es inválida");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  void updateMotivos(String servicio) async {
    if (servicio != '------------ servicio ------------') {
      print(servicio);
      _motivoServicio.clear(); // Limpiar la lista de modelos

      _clasificacionFalla.clear();
      _clasificacionFalla = [
        '---------- clasificacion ----------',
      ];
      _causaRaiz.clear(); // Limpiar la lista de modelos
      _causaRaiz = [
        '---------- causa raiz ----------',
      ];
      _especificarFalla.clear(); // Limpiar la lista de modelos
      _especificarFalla = [
        '--------- especificar falla ---------',
      ];

      if (servicio == 'Garantía') {
        _motivoServicio = [
          '------------ servicio ------------',
          'Instalación de Refacción',
          'Diagnóstico',
          'Envío a Taller',
        ];
      } else if (servicio == 'Servicio Pagado') {
        _motivoServicio = [
          '------------ servicio ------------',
          'Instalación de Refacción',
          'Envío a Taller',
          'Diagnóstico',
          'Capacitación',
          'Reubicación de Equipo',
          'Mantenimiento Preventivo',
          'Mantenimiento Correctivo'
        ];
      } else if (servicio == 'Instalación y Capacitación') {
        _motivoServicio = [
          '------------ servicio ------------',
          'Instalación de Equipo',
          'Capacitación'
        ];
      } else if (servicio == 'Por Definir') {
        _motivoServicio = [
          '------------ servicio ------------',
          'Instalación de Refacción',
          'Diagnóstico',
          'Envío a Taller',
          'Reubicación de Equipo',
          'Mantenimiento Preventivo',
          'Mantenimiento Correctivo'
        ];
      }

      setState(() {
        _selectedMotivo =
            _motivoServicio.first; // Actualizar el valor seleccionado

        _selectedClasificacion =
            _clasificacionFalla.first; // Actualizar el valor seleccionado

        _selectedCausaRaiz =
            _causaRaiz.first; // Actualizar el valor seleccionado

        _selectedEspecificarFalla =
            _especificarFalla.first; // Actualizar el valor seleccionado
      });
      print(_motivoServicio);
    } else {
      print("El servicio seleccionado es inválido");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  void updateClasificacion(String hoja) async {
    if (hoja != '---------- ultima hoja ----------') {
      print(hoja);
      _clasificacionFalla.clear(); // Limpiar la lista de modelos

      if (hoja == 'Sí' &&
          (_selectedMotivo == 'Instalación de Refacción' ||
              _selectedMotivo == 'Diagnóstico' ||
              _selectedMotivo == 'Mantenimiento Correctivo')) {
        _clasificacionFalla = [
          '---------- clasificacion ----------',
          'Mano de obra (Operador)',
          'Máquina (Equipo AR)',
          'Material(es)',
          'Falta de mantenimiento',
          'Instalación fuera de estándar',
        ];
      } else {
        _clasificacionFalla = [
          '---------- clasificacion ----------',
        ];

        _causaRaiz.clear(); // Limpiar la lista de modelos
        _causaRaiz = [
          '---------- causa raiz ----------',
        ];
        _especificarFalla.clear(); // Limpiar la lista de modelos
        _especificarFalla = [
          '--------- especificar falla ---------',
        ];
      }

      setState(() {
        _selectedClasificacion =
            _clasificacionFalla.first; // Actualizar el valor seleccionado

        _selectedCausaRaiz = _causaRaiz.first;

        _selectedEspecificarFalla = _especificarFalla.first;
      });
      print(_clasificacionFalla);
    } else {
      print("Ultima hoja seleccionado es inválido");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  void updateClasificacionPorMotivo(String motivo) async {
    if (motivo != '------------ motivo ------------') {
      print(motivo);
      _clasificacionFalla.clear(); // Limpiar la lista de modelos

      if (_selectedUltimaHoja == 'Sí' &&
          (motivo == 'Instalación de Refacción' ||
              motivo == 'Diagnóstico' ||
              motivo == 'Mantenimiento Correctivo')) {
        _clasificacionFalla = [
          '---------- clasificacion ----------',
          'Mano de obra (Operador)',
          'Máquina (Equipo AR)',
          'Material(es)',
          'Falta de mantenimiento',
          'Instalación fuera de estándar',
        ];
      } else {
        _clasificacionFalla = [
          '---------- clasificacion ----------',
        ];

        _causaRaiz.clear(); // Limpiar la lista de modelos
        _causaRaiz = [
          '---------- causa raiz ----------',
        ];
        _especificarFalla.clear(); // Limpiar la lista de modelos
        _especificarFalla = [
          '--------- especificar falla ---------',
        ];
      }

      setState(() {
        _selectedClasificacion =
            _clasificacionFalla.first; // Actualizar el valor seleccionado

        _selectedCausaRaiz = _causaRaiz.first;

        _selectedEspecificarFalla = _especificarFalla.first;
      });
      print(_clasificacionFalla);
    } else {
      print("Ultima hoja seleccionado es inválido");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  void updateCausaRaiz(String clasificacion) async {
    if (clasificacion != '---------- clasificacion ----------') {
      print(clasificacion);
      _causaRaiz.clear(); // Limpiar la lista de modelos

      if (clasificacion == 'Mano de obra (Operador)') {
        _causaRaiz = [
          '---------- causa raiz ----------',
          'Operador no capacitado',
          'Operador no calificado',
          'Error de operación',
          'Uso de máquina con parámetros fuera de rango',
        ];
      } else if (clasificacion == 'Máquina (Equipo AR)') {
        _causaRaiz = [
          '---------- causa raiz ----------',
          'Desgaste',
          'Cumplió su vida útil',
          'Defecto de fabricación',
          'Componente defectuoso de proveedor',
          'Especificación de la máquina no es adecuada',
          'Componente/accesorio fuera de especificación',
        ];
      } else if (clasificacion == 'Material(es)') {
        _causaRaiz = [
          '---------- causa raiz ----------',
          'La especificación del material no es acorde',
          'Método (Uso de la máquina)',
        ];
      } else if (clasificacion == 'Falta de mantenimiento') {
        _causaRaiz = [
          '---------- causa raiz ----------',
          'Falta de mantenimiento preventivo',
          'Daño por mantenimiento por personal no calificado',
          'Uso del equipo bajo condiciones no aptas',
          'Uso de componente o accesorio de apoyo con falla',
        ];
      } else if (clasificacion == 'Instalación fuera de estándar') {
        _causaRaiz = [
          '---------- causa raiz ----------',
          'Piso desnivelado',
          'Máquina instalada en área abierta',
          'Exceso de suciedad',
          'Área no ventilada',
          'Alimentación eléctrica fuera de estándar',
          'Cable de alimentación fuera de especificación',
          'Equipo no aterrizado'
        ];
      } else {
        _causaRaiz = [
          '---------- causa raiz ----------',
        ];
      }

      setState(() {
        _selectedCausaRaiz =
            _causaRaiz.first; // Actualizar el valor seleccionado
      });
      print(_causaRaiz);
    } else {
      print("La clasificación que has seleccionado es inválida");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  void updateEspecificarFalla(String causa) async {
    if (causa != '---------- causa raiz ----------') {
      print(causa);
      _especificarFalla.clear(); // Limpiar la lista de modelos

      if (causa == 'Componente/accesorio fuera de especificación') {
        _especificarFalla = [
          '--------- especificar falla ---------',
          'Chiller',
          'Sistema de extracción',
          'Sistema SAAP (Incluido en el equipo)',
          'Fuente de alimentación de aíre del cliente',
        ];
      } else if (causa == 'Método (Uso de la máquina)') {
        _especificarFalla = [
          '--------- especificar falla ---------',
          'Uso inadecuado de la máquina',
          'Uso de herramienta de corte inadecuada',
        ];
      } else {
        _especificarFalla = [
          '--------- especificar falla ---------',
        ];
      }

      setState(() {
        _selectedEspecificarFalla =
            _especificarFalla.first; // Actualizar el valor seleccionado
      });
      print(_especificarFalla);
    } else {
      print("La clasificación que has seleccionado es inválida");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  void updateActividades(String equipo) async {
    if (equipo != '------------ equipo ------------') {
      print(equipo);
      String actividadesJson =
          await rootBundle.loadString('lib/images/actividades.json');
      actividades = json.decode(actividadesJson);
      final actividad = actividades['actividades'] as List<dynamic>;

      // Buscar el array de máquinas correspondiente a la familia seleccionada
      final actividadesEquipo = actividad.firstWhere(
          (registro) => registro['maquina'] == equipo,
          orElse: () => null);

      if (actividadesEquipo != null) {
        final actividadesList = actividadesEquipo['info'] as List<dynamic>?;

        if (actividadesList != null) {
          tipos = actividadesList
              .map((objeto) => objeto["tipo"].toString())
              .toList();
          tiemposAct = actividadesList
              .map((objeto) => objeto["tiempo"].toString())
              .toList();
          selectedTags.clear(); // Limpiar la lista de modelos
          availableTags.clear();
          availableTags
              .addAll(tipos.cast<String>()); // Agregar nuevas actividades
          print(availableTags);
        } else {
          print('No se encontraron actividades para la maquina seleccionada');
        }
      }
    } else {
      selectedTags.clear(); // Limpiar la lista de modelos
      availableTags.clear();
      print("La maquina seleccionada es inválida");
    }
    setState(() {
      // Actualiza el estado del widget si es necesario
    });
  }

  Future<void> cargarMaquina(String productId, List ticketData) async {
    try {
      print(productId);
      final response = await http.get(Uri.parse(
          'https://script.google.com/macros/s/AKfycbzB8XlDFKIzh0LyA8V04OYqVrG0rKcSSm756zTj2opGEiacp6NGRhLWAENwyJ86892E/exec?productId=$productId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        _razonSocialController.text =
            ticketData.length > 1 ? ticketData[1] : '';
        _contactoController.text = ticketData.length > 2 ? ticketData[2] : '';
        _correoClienteController.text =
            ticketData.length > 3 ? ticketData[3] : '';

        var nombreMaq = data["data"]["nombreMaq"];
        _maquinaController.text = nombreMaq;
        var noSerie = data["data"]["noSerie"];
        _noSerieController.text = noSerie;
        print(noSerie);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> signOutWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future logOut() async {
    FirebaseAuth.instance.signOut();
    await signOutWithGoogle();
  }

  @override
  void initState() {
    super.initState();
    // Inicializar los valores de los controladores de texto aquí
    _razonSocialController.text = "";
    _contactoController.text = "";
    _correoClienteController.text = "";
    _maquinaController.text = "";
    _noSerieController.text = "";
    _horaComidaController.text = "";
    _trabajoRealizadoController.text = "";
    _observacionesController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    String displayName = user.displayName ?? 'Desconocido';
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(22, 23, 24, 0.8), // Cambio de color a negro
        title: ClipRRect(
          borderRadius: BorderRadius.circular(
              4), // Ajusta el valor del radio según tus preferencias
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
              const Text('Hoja Servicio'),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<List<String>>>(
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
            return Center(
              child: Text('Ocurrió un error: ${snapshot.error}'),
            );
          } else if (guardandoDatos == true) {
            return Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('lib/images/logo_cargando.gif'),
              ),
            );
          } else {
            data = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Usuario AR: ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " $displayName",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Correo AR:  ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " ${user.email!}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: dropdownValue,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText:
                                    'Ticket', // Agregamos la etiqueta "Ticket"
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 255, 249, 249),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  updateRazonSocial(
                                      newValue!); // Agrega esta línea para actualizar la razón social
                                });
                              },
                              items: tickets
                                  .toList()
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Razón Social',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el cliente';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _razonSocialController.text = value!;
                              },
                              controller:
                                  _razonSocialController, // Agrega esta línea
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Maquina',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese la maquina';
                                }
                                // Aquí puedes agregar validaciones adicionales para el formato del correo electrónico
                                return null;
                              },
                              onSaved: (value) {
                                _maquinaController.text = value!;
                              },
                              controller: _maquinaController,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Número de Serie',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese la serie';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _noSerieController.text = value!;
                              },
                              controller:
                                  _noSerieController, // Agrega esta línea
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Contacto',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el contacto';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _contactoController.text = value!;
                              },
                              controller:
                                  _contactoController, // Agrega esta línea
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Correo del Cliente',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el correo';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _correoClienteController.text = value!;
                              },
                              controller:
                                  _correoClienteController, // Agrega esta línea
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Teléfono del Cliente',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el teléfono';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _numeroClienteController.text = value!;
                              },
                              controller:
                                  _numeroClienteController, // Agrega esta línea
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      this.selectedDate = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                      );
                                      dateController.text =
                                          dateFormatter.format(selectedDate);
                                    });
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Fecha del Servicio',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                // Agrega cualquier otra configuración de estilo que desees
                              ),
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedTipoServicio,
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Servicio',
                                border: OutlineInputBorder(),
                              ),
                              items: _tiposServicio.map((String tipoServicio) {
                                return DropdownMenuItem<String>(
                                  value: tipoServicio,
                                  child: Text(tipoServicio),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _selectedTipoServicio = newValue;
                                  updateMotivos(newValue);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedMotivo,
                              decoration: const InputDecoration(
                                labelText: 'Motivo de Servicio',
                                border: OutlineInputBorder(),
                              ),
                              items: _motivoServicio.map((String motivo) {
                                return DropdownMenuItem<String>(
                                  value: motivo,
                                  child: Text(motivo),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMotivo = newValue;
                                  updateClasificacionPorMotivo(newValue!);
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedLocalidadServicio,
                              decoration: const InputDecoration(
                                labelText: 'Localidad del Servicio',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  _localidadesServicio.map((String servicio) {
                                return DropdownMenuItem<String>(
                                  value: servicio,
                                  child: Text(servicio),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _selectedLocalidadServicio = newValue;
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedUltimaHoja,
                              decoration: const InputDecoration(
                                labelText: '¿Última Hoja?',
                                border: OutlineInputBorder(),
                              ),
                              items: _ultimaHoja.map((String servicio) {
                                return DropdownMenuItem<String>(
                                  value: servicio,
                                  child: Text(servicio),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _selectedUltimaHoja = newValue;
                                  if (newValue != 'Sí') {
                                    _hojasServicioController.clear();
                                    selectedTags
                                        .clear(); // Limpiar la lista de modelos
                                    availableTags.clear();
                                  }
                                  updateClasificacion(newValue);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _horaLlegadaController,
                              readOnly: true,
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _horaLlegadaController.text =
                                        _timeFormat.format(DateTime(
                                            1, 1, 1, time.hour, time.minute));
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Hora de Llegada con el Cliente',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                // Agrega cualquier otra configuración de estilo que desees
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _horaSalidaController,
                              readOnly: true,
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _horaSalidaController.text =
                                        _timeFormat.format(DateTime(
                                            1, 1, 1, time.hour, time.minute));
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Hora de Salida con el Cliente',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                // Agrega cualquier otra configuración de estilo que desees
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _horaComidaController,
                              decoration: InputDecoration(
                                labelText: 'Tiempo de comida (hrs)',
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
                                  initialTime:
                                      const TimeOfDay(hour: 1, minute: 00),
                                  initialEntryMode: TimePickerEntryMode.input,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                );
                                if (time != null) {
                                  setState(() {
                                    _horaComidaController.text =
                                        '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _hojasServicioController,
                              decoration: InputDecoration(
                                labelText:
                                    '¿Cuantas hojas de servicio llenaste?',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              enabled: _selectedUltimaHoja ==
                                  'Sí', // Habilitar cuando se selecciona 'Sí'
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedFamilia,
                              decoration: const InputDecoration(
                                labelText: 'Familia',
                                border: OutlineInputBorder(),
                              ),
                              items: _familiasEq.map((String familia) {
                                return DropdownMenuItem<String>(
                                  value: familia,
                                  child: Text(familia),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFamilia = newValue;
                                  updateEquipos(
                                      newValue!); // Agrega esta línea para actualizar
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedEquipo,
                              decoration: const InputDecoration(
                                labelText: 'Modelo',
                                border: OutlineInputBorder(),
                              ),
                              items: _equipo.map((String modelo) {
                                return DropdownMenuItem<String>(
                                  value: modelo,
                                  child: Text(modelo),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedEquipo = newValue;
                                  if (_selectedUltimaHoja == 'Sí') {
                                    updateActividades(newValue!);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedClasificacion,
                              decoration: const InputDecoration(
                                labelText: 'Clasificación de Falla',
                                border: OutlineInputBorder(),
                              ),
                              items: _clasificacionFalla
                                  .map((String clasificacion) {
                                return DropdownMenuItem<String>(
                                  value: clasificacion,
                                  child: Text(
                                    clasificacion,
                                    style: const TextStyle(
                                        fontSize:
                                            14), // Establece el tamaño de letra deseado
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedClasificacion = newValue;
                                  updateCausaRaiz(newValue!);
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedCausaRaiz,
                              decoration: const InputDecoration(
                                labelText: 'Causa Raíz',
                                border: OutlineInputBorder(),
                              ),
                              items: _causaRaiz.map((String causa) {
                                return DropdownMenuItem<String>(
                                  value: causa,
                                  child: Text(
                                    causa,
                                    style: const TextStyle(
                                        fontSize:
                                            14), // Establece el tamaño de letra deseado
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCausaRaiz = newValue;
                                  updateEspecificarFalla(newValue!);
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _selectedEspecificarFalla,
                              decoration: const InputDecoration(
                                labelText: 'Especificar la Falla (si aplica)',
                                border: OutlineInputBorder(),
                              ),
                              items: _especificarFalla.map((String falla) {
                                return DropdownMenuItem<String>(
                                  value: falla,
                                  child: Text(
                                    falla,
                                    style: const TextStyle(
                                        fontSize:
                                            14), // Establece el tamaño de letra deseado
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedEspecificarFalla = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () async {
                                print("Trabajo Realizado");
                                // Navegar a la vista TrabajoRealizadoPage y pasar el valor del campo
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrabajoRealizadoPage(
                                        trabajoRealizado:
                                            _trabajoRealizadoController.text),
                                  ),
                                );
                                // Actualizar el valor del campo con el resultado
                                if (result != null) {
                                  setState(() {
                                    _trabajoRealizadoController.text = result;
                                  });
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                    ),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                    ),
                                  ),
                                  labelText: 'Trabajo Realizado',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  labelStyle: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors
                                      .black, // Establece el color del texto deshabilitado
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, ingrese la tarea';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _trabajoRealizadoController.text = value!;
                                },
                                controller: _trabajoRealizadoController,
                              ),
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () async {
                                print(
                                    "Observaciones y/o Recomendaciones al Cliente");
                                // Navegar a la vista TrabajoRealizadoPage y pasar el valor del campo
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ObservacionesPage(
                                          observaciones:
                                              _observacionesController.text)),
                                );
                                // Actualizar el valor del campo con el resultado
                                if (result != null) {
                                  setState(() {
                                    _observacionesController.text = result;
                                  });
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                    ),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                    ),
                                  ),
                                  labelText:
                                      'Observaciones y/o Recomendaciones al Cliente',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  labelStyle: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors
                                      .black, // Establece el color del texto deshabilitado
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, ingrese las observaciones';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _observacionesController.text = value!;
                                },
                                controller: _observacionesController,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Actividades Realizadas",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: availableTags.map((tag) {
                                    final isSelected =
                                        selectedTags.contains(tag);
                                    return ChoiceChip(
                                      label: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      selected: isSelected,
                                      selectedColor: const Color.fromARGB(
                                          255, 228, 59, 47),
                                      onSelected: (isSelected) {
                                        setState(() {
                                          if (isSelected) {
                                            selectedTags.add(tag);
                                          } else {
                                            selectedTags.remove(tag);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: _submitForm,
                              child: const Text('Enviar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
