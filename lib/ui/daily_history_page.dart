import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:med_sync_app_movil/ui/home_page.dart';
import 'package:med_sync_app_movil/ui/profile_page.dart';

class DailyHistoryPage extends StatefulWidget {
  @override
  _DailyHistoryPageState createState() => _DailyHistoryPageState();
}

class _DailyHistoryPageState extends State<DailyHistoryPage> {
  List<Map<String, dynamic>> dailyData = [];
  String token = "";
  int patientId = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokenAndPatientId();
  }

  // Cargar el token y el id del paciente desde SharedPreferences y obtener los datos de métricas
  Future<void> _loadTokenAndPatientId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedToken = prefs.getString('authToken') ?? "";
    int savedPatientId = prefs.getInt('userId') ?? 0;

    setState(() {
      token = savedToken;
      patientId = savedPatientId;
    });

    if (token.isNotEmpty && patientId != 0) {
      await _fetchMetricsData();
    } else {
      print('Token o id de paciente no encontrado en SharedPreferences');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para obtener los datos de métricas desde la API
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
        setState(() {
          dailyData = data.map((metric) {
            // Convertir la fecha del array [year, month, day] a un string legible
            List<dynamic> dateArray = metric['date'];
            String formattedDate = "${_getDayOfWeek(DateTime(dateArray[0], dateArray[1], dateArray[2]))}, ${dateArray[2]} de ${_getMonthName(dateArray[1])} ${dateArray[0]}";

            return {
              "date": formattedDate,
              "average": (metric['average'] ?? 0).toInt(),
              "maxFrequency": (metric['maxFrequency'] ?? 0).toInt(),
              "minFrequency": (metric['minFrequency'] ?? 0).toInt(),
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('Error al obtener los datos de métricas: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Obtener el nombre del día de la semana
  String _getDayOfWeek(DateTime date) {
    List<String> days = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
    return days[date.weekday % 7];
  }

  // Obtener el nombre del mes
  String _getMonthName(int month) {
    List<String> months = [
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial diario"),
        backgroundColor: Colors.cyan,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostrar un indicador de carga mientras se obtienen los datos
          : ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: dailyData.length,
        itemBuilder: (context, index) {
          final data = dailyData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["date"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Promedio diario: ${data["average"]} latidos por minuto",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Frecuencia máxima en el día: ${data["maxFrequency"]} latidos por minuto",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Frecuencia mínima en el día: ${data["minFrequency"]} latidos por minuto",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
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
        },
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