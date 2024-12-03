// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:Entregas/pages/pedidos_gps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class OpenStreetMapPage extends StatefulWidget {
  final Function(String)? onDistanceChanged;

  const OpenStreetMapPage({super.key, this.onDistanceChanged});

  @override
  State<OpenStreetMapPage> createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  final locationController = Location();
  final pedidoController = TextEditingController();
  final clienteController = TextEditingController();
final destinationController = TextEditingController();

  LatLng? currentPosition;
  LatLng? startPosition;
  LatLng? destinationPosition;
  List<LatLng> destinationPositions = [];
  List<LatLng> polylineCoordinates = [];
  MapController mapController = MapController();
  Set<Marker> markers = {};
  List<PedidoData> pedidos = [];
  List<dynamic> pedidosList = [];

  String? distance;
  String? duration;

  bool isLoading = false;
  bool primeraVez = true;
  bool showAgregarButton = true;

  List<String> maquinas = [];
  String? selectedMaquina;
  String? selectedPedido;

  bool showForm = false;

  StreamSubscription<LocationData>? locationSubscription;

  void updateDistance(String newDistance) {
    setState(() {
      distance = newDistance;
      primeraVez = true;
      distance = null;
      markers.clear();
      destinationPositions.clear();
      polylineCoordinates.clear();

      pedidos.clear();

      pedidoController.clear();
      clienteController.clear();
      destinationController.clear();
      selectedMaquina = null;
      showAgregarButton = true;
    });
    if (widget.onDistanceChanged != null) {
      widget.onDistanceChanged!(newDistance);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeMap();
      await fetchPedidos();
    });
    fetchMaquinas();
    setState(() {
      primeraVez = true;
    });
    resetMap();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    pedidoController.dispose();
    clienteController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }

  Future<void> fetchMaquinas() async {
    final response =
        await http.get(Uri.parse('https://teknia.app/api/all_maquinas/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        maquinas = ['']
            .followedBy(data.map((item) => item['maquina'] as String))
            .toList();
      });
    } else {
      throw Exception('Error al cargar las máquinas');
    }
  }

  Future<void> fetchPedidos() async {
    final response = await http
        .get(Uri.parse('https://teknia.app/api9/solicitudes_grua_confirmadas'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pedidosList = data;
      });
    } else {
      throw Exception('Error al cargar los pedidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: currentPosition!,
                    zoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: markers.toList(),
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: polylineCoordinates,
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
          if (distance != null &&
              duration != null &&
              distance != "Nueva distancia")
            Positioned(
              top: 34,
              left: 10,
              right: 10,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_run, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Distancia: ${double.parse(distance ?? "0").toStringAsFixed(2)} km',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Tiempo estimado: ${double.parse(duration ?? "0") > 60 ? '${(double.parse(duration ?? "0") ~/ 60)} hrs ${(double.parse(duration ?? "0") % 60).round()} min' : '${double.parse(duration ?? "0").round()} min'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (showForm)
            Positioned(
              top: 112,
              left: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedPedido,
                        hint: const Text('Seleccione el pedido'),
                        items: pedidosList.map((pedido) {
                          return DropdownMenuItem<String>(
                            value: pedido['pedido'],
                            child: Text(pedido['pedido']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPedido = value;
                            final selected = pedidosList.firstWhere(
                                (pedido) => pedido['pedido'] == value);
                            pedidoController.text = selected['pedido'];
                            clienteController.text = selected['razon_social'];
                            selectedMaquina = selected['modelo'];
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // TextField(
                      //   controller: pedidoController,
                      //   decoration: InputDecoration(
                      //     hintText: 'Pedido',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     contentPadding: const EdgeInsets.symmetric(
                      //       vertical: 10.0,
                      //       horizontal: 14.0,
                      //     ),
                      //     labelStyle: const TextStyle(
                      //       fontSize: 12.0,
                      //       fontWeight: FontWeight.normal,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      //   enabled: false,
                      // ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: clienteController,
                        decoration: InputDecoration(
                          hintText: 'Cliente',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 14.0,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller:
                            TextEditingController(text: selectedMaquina),
                        onChanged: (value) {
                          setState(() {
                            selectedMaquina = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Ingrese máquina',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 14.0,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: destinationController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese destino',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 14.0,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (showAgregarButton)
                            ElevatedButton(
                              onPressed: () {
                                if (pedidoController.text.isEmpty ||
                                    clienteController.text.isEmpty ||
                                    selectedMaquina == null ||
                                    destinationController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Por favor, complete todos los campos.'),
                                    ),
                                  );
                                } else {
                                  FocusScope.of(context).unfocus();
                                  fetchPolylinePoints(
                                      destinationController.text, "Agregar");
                                }
                              },
                              child: const Text('Agregar'),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              resetMap();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 230, 30, 11)),
                            ),
                            child: const Text(
                              'Cancelar Ruta',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (distance != null &&
              duration != null &&
              distance != "Nueva distancia")
            Positioned(
              bottom: 2,
              left: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdenEntregaPage(
                          pedidos: pedidos,
                          onDistanceChanged: updateDistance,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 83, 85, 236),
                    ),
                  ),
                  child: const Text(
                    'Iniciar Orden de Entrega',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 70,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  showForm =
                      true; // Muestra el formulario nuevamente al hacer clic en el botón de más
                });
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 11,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                resetMap();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 17, 151, 62),
                ),
              ),
              child: const Text(
                'Borrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 6.0,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Cargando...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription =
        locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          if (primeraVez) {
            markers.add(
              Marker(
                point: currentPosition!,
                builder: (context) => const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 40.0,
                ),
              ),
            );
          }
          primeraVez = false;
        });
      }
    });
  }

  LatLngBounds calculateBounds(List<LatLng> coordinates) {
    double? minLat, maxLat, minLng, maxLng;

    for (var coord in coordinates) {
      if (minLat == null || coord.latitude < minLat) {
        minLat = coord.latitude;
      }
      if (maxLat == null || coord.latitude > maxLat) {
        maxLat = coord.latitude;
      }
      if (minLng == null || coord.longitude < minLng) {
        minLng = coord.longitude;
      }
      if (maxLng == null || coord.longitude > maxLng) {
        maxLng = coord.longitude;
      }
    }

    return LatLngBounds(LatLng(minLat!, minLng!), LatLng(maxLat!, maxLng!));
  }

  Future<Map<String, dynamic>> fetchPolyline(LatLng start, LatLng end) async {
    final response = await http.get(Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0];
      final geometry = route['geometry'];
      final coordinates = geometry['coordinates'] as List;

      final distance = route['distance'] / 1000;
      final duration = route['duration'] / 60;

      final polylineCoordinates = coordinates.map((point) {
        final lat = point[1].toDouble();
        final lng = point[0].toDouble();
        return LatLng(lat, lng);
      }).toList();

      return {
        'coordinates': polylineCoordinates,
        'distance': distance,
        'duration': duration,
      };
    } else {
      throw Exception('Failed to load polyline');
    }
  }

  Future<Map<String, String>> fetchAddressDetails(LatLng position) async {
  final response = await http.get(Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=10&addressdetails=1'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final address = data['address'];

    // Registra la respuesta JSON para depuración
    debugPrint('Response from Nominatim: $data');

    String city = 'Unknown';
    String state = 'Unknown';

    // Extraer la ciudad de diferentes posibles campos
    if (address.containsKey('city')) {
      city = address['city'];
    } else if (address.containsKey('town')) {
      city = address['town'];
    } else if (address.containsKey('village')) {
      city = address['village'];
    } else if (address.containsKey('hamlet')) {
      city = address['hamlet'];
    } else if (address.containsKey('suburb')) {
      city = address['suburb'];
    } else if (address.containsKey('county')) {
      city = address['county'];
    }

    // Extraer el estado
    if (address.containsKey('state')) {
      state = address['state'];
    } else if (address.containsKey('province')) {
      state = address['province'];
    } else if (address.containsKey('region')) {
      state = address['region'];
    } else if (address.containsKey('state_district')) {
      state = address['state_district'];
    } else if (address.containsKey('county')) {
      state = address['county'];
    }

    return {'city': city, 'state': state};
  } else {
    throw Exception('Failed to load address details');
  }
}


  Future<void> fetchPolylinePoints(String destination, String status) async {
    if (currentPosition == null) return;

    Completer<void> completer = Completer<void>();
    showAgregarButton = false;
    isLoading = true;

    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzxXSAKr5v6NDgjlaMOOkTKnIi6qvGdl7erw5qeGEHLIGqOfnVTknIZeTpZbosHih8m_g/exec?address=$destination'));

    final timer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer
            .completeError('Lugar no encontrado o tiempo de espera agotado');
      }
    });

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('coordinates')) {
          final List<dynamic> coordinates = data['coordinates'];
          if (coordinates.isNotEmpty) {
            final destinationLatLng = LatLng(
              coordinates[0],
              coordinates[1],
            );

            final addressDetails = await fetchAddressDetails(destinationLatLng);
            String city = addressDetails['city'] ?? "";
            String stateProvince = addressDetails['state'] ?? "";

            setState(() {
              destinationPosition = destinationLatLng;
              destinationPositions.add(destinationLatLng);
              markers.add(
                Marker(
                  point: destinationLatLng,
                  builder: (context) => const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              );
            });

            LatLng startPoint;
            if (destinationPositions.length > 1) {
              startPoint =
                  destinationPositions[destinationPositions.length - 2];
            } else {
              startPoint = currentPosition!;
            }

            final polylineData =
                await fetchPolyline(startPoint, destinationLatLng);

            LatLngBounds bounds =
                calculateBounds(polylineData['coordinates'] as List<LatLng>);
            mapController.fitBounds(
              bounds,
              options: const FitBoundsOptions(
                padding: EdgeInsets.all(18.0),
              ),
            );

            final polylineCoordinates =
                polylineData['coordinates'] as List<LatLng>;
            final distance = polylineData['distance'] as double;
            final duration = polylineData['duration'] as double;

            setState(() {
              this.polylineCoordinates.addAll(polylineCoordinates);
              if (this.distance == null) {
                this.distance = distance.toStringAsFixed(2);
              } else {
                this.distance = (double.parse(this.distance!) + distance)
                    .toStringAsFixed(2);
              }
              if (this.duration == null) {
                this.duration = duration.toStringAsFixed(2);
              } else {
                this.duration = (double.parse(this.duration!) + duration)
                    .toStringAsFixed(2);
              }
            });

            completer.complete();

            if (pedidoController.text.isNotEmpty && selectedMaquina != null) {
              final selectedPedidoData = pedidosList.firstWhere(
                  (pedido) => pedido['pedido'] == pedidoController.text);
              PedidoData nuevoPedido = PedidoData(
                pedido: pedidoController.text,
                cliente: clienteController.text,
                maquina: selectedMaquina!,
                destination: destination,
                distance: distance.toString(),
                duration: duration.toString(),
                city: city,
                stateProvince:
                    stateProvince, // Add state/province to the pedido
                idOrdenEntrega:
                    selectedPedidoData['id_orden_entrega'].toString(),
              );
              pedidos.add(nuevoPedido);
              pedidoController.clear();
              clienteController.clear();
              destinationController.clear();
              selectedMaquina = null;
              setState(() {
                showAgregarButton = true;
                showForm = false;
                isLoading = false;
              });
            }
          } else {
            throw Exception('Lugar no encontrado');
          }
        } else {
          throw Exception('Lugar no encontrado');
        }
      } else {
        throw Exception('Lugar no encontrado');
      }
    } catch (error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    } finally {
      timer.cancel();
      if (isLoading) {
        setState(() {
          isLoading = false;
          showAgregarButton = true;
        });
      }
    }

    try {
      await completer.future;
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void resetMap() {
    setState(() {
      primeraVez = true;
      distance = null;
      markers.clear();
      destinationPositions.clear();
      polylineCoordinates.clear();

      pedidos.clear();

      pedidoController.clear();
      clienteController.clear();
      destinationController.clear();
      selectedMaquina = null;
      showAgregarButton = true;
    });
  }
}

class PedidoData {
  final String pedido;
  final String cliente;
  final String maquina;
  final String destination;
  final String distance;
  final String duration;
  final String city;
  final String stateProvince;
  final String idOrdenEntrega; // Nuevo campo

  PedidoData({
    required this.pedido,
    required this.cliente,
    required this.maquina,
    required this.destination,
    required this.distance,
    required this.duration,
    required this.city,
    required this.stateProvince,
    required this.idOrdenEntrega,
  });
}
