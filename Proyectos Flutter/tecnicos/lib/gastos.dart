// ignore_for_file: camel_case_types, avoid_print, non_constant_identifier_names, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert'; // Para decodificar el JSON
import 'package:http/http.dart' as http; // Para hacer la solicitud HTTP
import 'package:intl/intl.dart';

class gastoss extends StatefulWidget {
  final String ticket;
  const gastoss({Key? key, required this.ticket}) : super(key: key);

  @override
  State<gastoss> createState() => _gastossState();
}

class _gastossState extends State<gastoss> {
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;
  bool _dataLoaded = false; // Indica si se cargaron datos desde la API

  @override
  void dispose() {
    // Cancela cualquier suscripción o temporizador aquí
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Función para obtener datos de la API
  Future<void> _fetchData() async {
    try {
      setState(() {
        _loading = true; // Cambia a true mientras se cargan los datos
      });
      final response = await http.get(Uri.parse(
          'https://teknia.app/api7/gastos/por_ticket/${widget.ticket}/armando.delarosa@asiarobotica.com'));
      // final response = await http.get(Uri.parse(
      //     'https://teknia.app/api7/gastos/por_ticket/166400/armando.delarosa@asiarobotica.com'));
      if (response.statusCode == 200) {
        setState(() {
          print(widget.ticket);
          _transactions =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
          _loading = false; // Cambia a false cuando se cargan los datos
          _dataLoaded = true; // Indica que se cargaron datos desde la API
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading =
            false; // Asegúrate de cambiar a false incluso si hay un error
      });
    }
  }

  void _newTransaction() {
    // Aquí puedes implementar la lógica para agregar una nueva transacción
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpense = 0;
    for (var transaction in _transactions) {
      // if (transaction['facturado']) {
      //   totalExpense += double.parse(transaction['monto']);
      // } else {
      totalIncome += double.parse(transaction['monto']);
      // }
    }

    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Row(
          children: [
            // Image.asset(
            //   'lib/images/log_asia.png',
            //   height: 50,
            //   width: 130,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'Gastos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TopNeuCard(
              balance: balance.toStringAsFixed(2),
              income: totalIncome.toStringAsFixed(2),
              expense: totalExpense.toStringAsFixed(2),
              ticket: widget.ticket,
            ),
            Expanded(
              child: Center(
                child: _loading
                    ? const LoadingCircle()
                    : _dataLoaded
                        ? _transactions.isEmpty
                            ? const Text('No hay gastos registrados')
                            : ListView.builder(
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = _transactions[index];
                                  return MyTransaction(
                                    fecha: transaction['fecha'],
                                    facturado:
                                        transaction['facturado'].toString(),
                                    metodo_pago: transaction['metodo_pago'],
                                    categoria: transaction['categoria'],
                                    transactionName: transaction['categoria'],
                                    money: transaction['monto'].toString(),
                                    expenseOrIncome: transaction['facturado']
                                        ? 'Expense'
                                        : 'Income',
                                  );
                                },
                              )
                        : const Text(
                            'Cargando datos...'), // Mostrar este mensaje mientras se cargan los datos
              ),
            ),
            PlusButton(
              function: _newTransaction,
              ticket: widget.ticket, // Pasar el valor del ticket aquí
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class TopNeuCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;
  final String ticket;

  const TopNeuCard({
    Key? key,
    required this.balance,
    required this.income,
    required this.ticket,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(
                4.0,
                4.0,
              ),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(
                -4.0,
                -4.0,
              ),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'T I C K E T',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          ticket,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_downward),
                                Column(
                                  children: [
                                    // Text('Gastos totales' + '\$$income'),
                                    Text(' Gastos totales:  \$$income'),
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     const Icon(Icons.arrow_downward),
                            //     Column(
                            //       children: [
                            //         const Text('expense'),
                            //         Text('\$$expense'),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTransaction extends StatefulWidget {
  final String transactionName;
  final String money;
  final String fecha;
  final String facturado;
  final String metodo_pago;
  final String categoria;
  final String expenseOrIncome;

  const MyTransaction({
    Key? key,
    required this.transactionName,
    required this.money,
    required this.fecha,
    required this.expenseOrIncome,
    required this.facturado,
    required this.metodo_pago,
    required this.categoria,
  }) : super(key: key);

  @override
  _MyTransactionState createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  bool _showMessage = false;

  @override
  Widget build(BuildContext context) {
    // Texto predeterminado si transactionName está vacío
    const String defaultTransactionName = 'Transacción sin nombre';
    // Texto predeterminado si money está vacío
    const String defaultMoney = 'Sin monto';

    String formattedDate(String dateString) {
      // Parse la cadena de fecha a un objeto DateTime
      DateTime date = DateTime.parse(dateString);

      // Cree un objeto DateFormat para formatear la fecha
      DateFormat formatter = DateFormat('dd/MM/yyyy');

      // Formatee la fecha y devuélvala como una cadena
      return formatter.format(date);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showMessage = !_showMessage;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(15),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[500],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.attach_money_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.transactionName.isNotEmpty
                                ? widget.transactionName
                                : defaultTransactionName),
                            Text(
                              'Monto: ${widget.money.isNotEmpty ? widget.money : defaultMoney}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.expenseOrIncome == 'expense' ? '+' : '-',
                      style: TextStyle(
                        color: (widget.expenseOrIncome == 'expense'
                            ? Colors.green
                            : Colors.red),
                      ),
                    ),
                  ],
                ),

                // Mostrar el mensaje si _showMessage es verdadero
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showMessage)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16), // Icono pequeño
                              const SizedBox(
                                  width:
                                      4), // Espacio entre el icono y el texto
                              Text(
                                'Fecha: ${widget.fecha.isNotEmpty ? formattedDate(widget.fecha) : ""}',
                              ), // Texto
                            ],
                          ),
                        ),
                      if (_showMessage)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Icono principal
                              const Icon(Icons.assignment,
                                  size: 16, color: Colors.black),
                              const SizedBox(
                                  width:
                                      4), // Espacio entre el icono principal y el texto
                              const Text(
                                'Facturado: ',
                                style: TextStyle(
                                    color: Colors.black), // Texto en negro
                              ),
                              // Icono de palomita verde si es true, rojo si es false
                              widget.facturado == 'true'
                                  ? const Icon(Icons.check_circle,
                                      size: 16, color: Colors.green)
                                  : const Icon(Icons.check_circle,
                                      size: 16, color: Colors.red),
                            ],
                          ),
                        ),
                      if (_showMessage)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.payment,
                                  size: 16), // Icono pequeño
                              const SizedBox(
                                  width:
                                      4), // Espacio entre el icono y el texto
                              Text(
                                  'Metodo_pago: ${widget.metodo_pago.isNotEmpty ? widget.metodo_pago : ""}'), // Texto
                            ],
                          ),
                        ),
                      if (_showMessage)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.category,
                                  size: 16), // Icono pequeño
                              const SizedBox(
                                  width:
                                      4), // Espacio entre el icono y el texto
                              Text(
                                  'Categoria: ${widget.categoria.isNotEmpty ? widget.categoria : ""}'), // Texto
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  final Function() function;
  final String ticket;
  PlusButton({Key? key, required this.function, required this.ticket})
      : super(key: key);

  String concepto = '';
  String fecha = '';
  String monto = '';
  String metodoPago = '';
  String facturado = '';
  String categoria = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Llamar a la función para mostrar el ModalBottomSheet
        showCustomDialogClutsh(context);
      },
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }

  // Función para mostrar el ModalBottomSheet
  void showCustomDialogClutsh(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.none,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            colorScheme:
                ColorScheme.light(primary: Colors.grey[800] ?? Colors.grey),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Agregar Gasto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Concepto de gasto',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onChanged: (value) {
                      concepto = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha y Hora del Gasto',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onChanged: (value) {
                      fecha = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Monto \$ MXN',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      monto = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Método de pago',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    items: <String>[
                      'One Card',
                      'Efectivo',
                      'Uber Business',
                      'Tag'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      metodoPago = value ?? '';
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Facturado',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    items: <String>[
                      'Si',
                      'No',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      facturado = value ?? '';
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    items: <String>[
                      'Paquetería',
                      'Alimento',
                      'Hospedaje/Alojamiento',
                      'Uber/Taxi',
                      'Combustible',
                      'Transporte (Autobus,Avión,etc.)',
                      'Casetas',
                      'Herramientas',
                      'Refacciónes',
                      'Otros',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      categoria = value ?? '';
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      print('Concepto: $concepto');
                      print('fecha: $fecha');
                      print('monto: $monto');
                      print('metodo_pago: $metodoPago');
                      print('facturado: $facturado');
                      print('categoria: $categoria');
                      print('Ticket: $ticket');

                      const String apiUrl = "https://teknia.app/api7/gastos/";

                      final Map<String, dynamic> gastoData = {
                        'concepto': concepto,
                        'fecha': fecha,
                        'monto': monto,
                        'metodo_pago': metodoPago,
                        'facturado': facturado,
                        'categoria': categoria,
                        'ticket': ticket, // Agrega el ticket aquí
                      };

                      try {
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          headers: {"Content-Type": "application/json"},
                          body: json.encode(gastoData),
                        );

                        if (response.statusCode == 201) {
                          Navigator.pop(context);
                        } else {
                          print('Error al crear el gasto: ${response.body}');
                        }
                      } catch (e) {
                        print('Error al conectar con la API: $e');
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
