// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gastos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ticketController = TextEditingController();
  List<String> gastos = [
    '57461',
    '5232',
    '23233',
    '23456',
    '34345',
    '67564',
    '23234',
    '65634',
    '67532',
    '343546',
  ];
  List<String> filteredGastos = [];
  bool showButton = false;
  String selectedTicket = '';
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    filteredGastos = [];
  }

  void _mostrarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(98, 89, 84, 84),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Buscar ticket',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ticketController,
                              onChanged: (value) {
                                setState(() {
                                  showButton = value.isNotEmpty;
                                  if (value.isNotEmpty) {
                                    filteredGastos = gastos
                                        .where((gasto) => gasto
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  } else {
                                    filteredGastos = [];
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Ticket',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(0, 255, 255, 255),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(0, 255, 255, 255),
                                  ),
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                prefixIcon: const Icon(
                                  Icons.confirmation_number_outlined,
                                  color: Colors.red,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(29, 156, 156, 156),
                              ),
                            ),
                          ),
                          if (showButton) const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (filteredGastos.isNotEmpty) const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredGastos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(filteredGastos[index]),
                            onTap: () {
                              setState(() {
                                selectedTicket = filteredGastos[index];
                              });
                              _ticketController
                                  .clear(); // Esto limpia el campo de texto
                              gastos.clear();
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, DateTime>>(
      context: context,
      builder: (BuildContext context) => DateSelectionScreen(
        rangeStart: _rangeStart,
        rangeEnd: _rangeEnd,
      ),
    );

    if (result != null) {
      setState(() {
        _rangeStart = result['start'];
        _rangeEnd = result['end'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 131, 129),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Gastos encontrados: ',
            ),
            ElevatedButton(
              onPressed: () {
                _mostrarModal(context);
              },
              child: const Text("Botón"),
            ),
            const SizedBox(height: 20),
            if (selectedTicket.isNotEmpty)
              Text(
                'Ticket seleccionado: $selectedTicket',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            DateTimePicker(
              rangeStart: _rangeStart,
              rangeEnd: _rangeEnd,
              onSelect: (DateTime? start, DateTime? end) {
                setState(() {
                  _rangeStart = start;
                  _rangeEnd = end;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final Function(DateTime?, DateTime?) onSelect;

  const DateTimePicker({
    Key? key,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => _showDatePicker(context),
            child: const Text("Filtro por fecha"),
          ),
          const SizedBox(height: 16),
          Text(
            'Rango seleccionado: ${rangeStart?.toString() ?? 'No seleccionado'} - ${rangeEnd?.toString() ?? 'No seleccionado'}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, DateTime>>(
      context: context,
      builder: (BuildContext context) => DateSelectionScreen(
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      ),
    );

    if (result != null) {
      onSelect(result['start'], result['end']);
    }
  }
}

class DateSelectionScreen extends StatefulWidget {
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  const DateSelectionScreen({Key? key, this.rangeStart, this.rangeEnd})
      : super(key: key);

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _rangeStart;
  late DateTime _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _rangeStart = widget.rangeStart ?? _focusedDay;
    _rangeEnd = widget.rangeEnd ?? _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = focusedDay;
      _focusedDay = focusedDay;
      _rangeStart = start ?? focusedDay;
      _rangeEnd = end ?? focusedDay;
    });
  }

  void _applyFilter() {
    Navigator.of(context).pop({'start': _rangeStart, 'end': _rangeEnd});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      child: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: _onDaySelected,
            rangeStartDay: _rangeStart,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            onRangeSelected: _onRangeSelected,
            rangeEndDay: _rangeEnd,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          ElevatedButton(
            onPressed: _applyFilter,
            child: const Text("Aplicar filtro"),
          ),
        ],
      ),
    );
  }
}
