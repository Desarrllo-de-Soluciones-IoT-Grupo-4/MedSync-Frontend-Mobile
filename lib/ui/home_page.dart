import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:med_sync_app_movil/ui/daily_history_page.dart';
import 'package:med_sync_app_movil/ui/profile_page.dart';

class HeartRateMonitorPage extends StatefulWidget {
  @override
  _HeartRateMonitorPageState createState() => _HeartRateMonitorPageState();
}

class _HeartRateMonitorPageState extends State<HeartRateMonitorPage> {
  int bpm = 35;
  int maxFrecuency = 50;
  int minFrecuency = 20;
  int _currentIndex = 0;
  String userName = "Usuario"; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Cargar el nombre del usuario al iniciar
  }

  // Método para cargar el nombre del usuario desde SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Usuario";
    });
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
        title: Row(
          children: [
            Image.asset(
              'assets/medsync_logo.png',
              height: 30,
            ),
            SizedBox(width: 8),
            Text('¡Hola, $userName!'), // Muestra el nombre del usuario
          ],
        ),
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
            Image.asset(
              'assets/grafico.png',
              height: 150,
            ),
            SizedBox(height: 10),
            Text(
              '$bpm bpm - ${bpm >= 60 && bpm <= 100 ? "Normal" : "Anormal"}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 5),
            Text(
              'Frecuencia mínima: $minFrecuency',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Frecuencia máxima: $maxFrecuency',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              'Última medida: 25/09/2024 21:02',
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