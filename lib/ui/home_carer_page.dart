import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:med_sync_app_movil/ui/daily_history_page.dart';
import 'package:med_sync_app_movil/ui/profile_page_carer.dart';

class PatientInfoPage extends StatelessWidget {
  final String patientName = "Esteban";
  final String patientLastName = "Fernández";
  final int bpm = 75;
  final int maxFrequency = 120;
  final int minFrequency = 60;

  void _callEmergency() async {
    final Uri emergencyNumber = Uri(scheme: 'tel', path: '911');
    if (await canLaunchUrl(emergencyNumber)) {
      await launchUrl(emergencyNumber);
    } else {
      print('No se pudo realizar la llamada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Paciente'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 15.0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 16),
                        Text(
                          "$patientName $patientLastName",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red, size: 28),
                        SizedBox(width: 8),
                        Text("BPM: $bpm", style: TextStyle(fontSize: 22, color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_alarm, color: Colors.blue, size: 28),
                        SizedBox(width: 8),
                        Text("Frecuencia Máxima: $maxFrequency", style: TextStyle(fontSize: 22, color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.green, size: 28),
                        SizedBox(width: 8),
                        Text("Frecuencia Mínima: $minFrequency", style: TextStyle(fontSize: 22, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _callEmergency,
                icon: Icon(Icons.phone, size: 24),
                label: Text("Llamar a Emergencias", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientInfoPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyHistoryPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageCarer()),
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

