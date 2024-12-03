import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? _adImageUrl;
  List<String> _bannerImages = [];
  int _currentBannerIndex = 0;
  bool _isAdVisible = true;
  bool _isBannerVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchAdAndBannerImages();
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateBannerImage();
    });
  }

  void _fetchAdAndBannerImages() async {
    final response = await http.get(Uri.parse('https://teknia.app/api8/publicidad'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _adImageUrl = data['bannerInicio'];
        _bannerImages = List<String>.from(data['bannerAbajo']);
        _isBannerVisible = _bannerImages.isNotEmpty;
      });
    } else {
      print('Error fetching ad and banner images');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _closeAd() {
    setState(() {
      _isAdVisible = false;
    });
  }

  void _updateBannerImage() {
    if (_bannerImages.isNotEmpty) {
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _bannerImages.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          if (_adImageUrl != null && _isAdVisible)
            Positioned(
              top: 135,
              left: 20,
              right: 20,
              child: Stack(
                children: [
                  Container(
                    height: 345, // Ajusta esta altura según tus necesidades
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _adImageUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _closeAd,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_isBannerVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60, // Altura fija para el banner inferior
                color: Colors.black, // Fondo negro para el banner
                child: AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: Image.network(
                    _bannerImages[_currentBannerIndex],
                    key: ValueKey<int>(_currentBannerIndex),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
