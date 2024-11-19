import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Importar para usar Timer

import 'package:intl/intl.dart'; // Importar para formatear la fecha
import 'package:med_sync_app_movil/ui/daily_history_page.dart';
import 'package:med_sync_app_movil/ui/profile_page.dart';

class HeartRateMonitorPage extends StatefulWidget {
  @override
  _HeartRateMonitorPageState createState() => _HeartRateMonitorPageState();
}

class _HeartRateMonitorPageState extends State<HeartRateMonitorPage> {
  int bpm = 0;
  int maxFrequency = 0;
  int minFrequency = 0;
  String lastModifiedDate = "";
  String token = "";
  int patientId = 0;
  String userName = "Usuario"; // Valor por defecto
  int _currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadTokenAndPatientId();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _fetchMetricsData();
    });
  }

  Future<void> _loadTokenAndPatientId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedToken = prefs.getString('authToken') ?? "";
    int savedPatientId = prefs.getInt('userId') ?? 0;

    setState(() {
      token = savedToken;
      patientId = savedPatientId;
    });

    if (token.isNotEmpty && patientId != 0) {
      await _fetchPatientName(); // Obtener el nombre del usuario desde la API
      await _fetchMetricsData();
    } else {
      print('Token o id de paciente no encontrado en SharedPreferences');
    }
  }

  // Método para obtener el nombre del usuario desde la API
  Future<void> _fetchPatientName() async {
    final url = Uri.parse('http://192.168.56.1:8080/api/v1/patients/$patientId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'] ?? "Usuario"; // Actualizar el nombre del usuario
        });
      } else {
        print('Error al obtener el nombre del paciente: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  Future<void> _fetchMetricsData() async {
    final url = Uri.parse('http://192.168.56.1:8080/api/v1/metrics?patientId=$patientId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final metric = data[0];
          setState(() {
            bpm = (metric['average'] ?? 0).toInt();
            maxFrequency = (metric['maxFrequency'] ?? 0).toInt();
            minFrequency = (metric['minFrequency'] ?? 0).toInt();

            // Formatear lastModifiedDate a fecha legible
            double lastModifiedTimestamp = (metric['patient']['lastModifiedDate'] ?? 0).toDouble();
            DateTime date = DateTime.fromMillisecondsSinceEpoch((lastModifiedTimestamp * 1000).toInt());
            lastModifiedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
          });
        }
      } else {
        print('Error al obtener los datos de métricas: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  Color getCircleColor(int bpm) {
    if (bpm <= 59 || bpm >= 181) {
      return Colors.red;
    } else if (bpm >= 60 && bpm <= 180) {
      return Colors.cyan;
    } else {
      return Colors.grey;
    }
  }

  void onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HeartRateMonitorPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DailyHistoryPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Hola, $userName!'), // Mostrar el nombre del usuario obtenido de la API
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Medición de ritmo cardíaco',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getCircleColor(bpm).withOpacity(0.2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$bpm',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: getCircleColor(bpm),
                      ),
                    ),
                    Text(
                      'bpm',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Frecuencia mínima: $minFrequency',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Frecuencia máxima: $maxFrequency',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Última medida: $lastModifiedDate',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cuenta',
          ),
        ],
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
