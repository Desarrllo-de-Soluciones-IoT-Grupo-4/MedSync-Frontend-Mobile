import 'package:flutter/material.dart';
import 'package:med_sync_app_movil/ui/daily_history_page.dart';
import 'package:med_sync_app_movil/ui/home_carer_page.dart';
import 'package:med_sync_app_movil/ui/login_page.dart';

class ProfilePageCarer extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageCarer> {
  String name = "Esteban Lórax";
  String lastName = "Fernández Pasco";
  String phoneNumber = "912345678";
  String profilePictureUrl = 'assets/profile_picture.png';

  void _showEditPhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController phoneController = TextEditingController(text: phoneNumber);

        return AlertDialog(
          title: Text("Editar Teléfono"),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'Teléfono'),
          ),
          actions: [
            TextButton(
              child: Text("Guardar"),
              onPressed: () {
                setState(() {
                  phoneNumber = phoneController.text;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HeartRateMonitorPage()));
          },
        ),
        title: Text("¡Hola, $name!"),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profilePictureUrl),
              ),
              SizedBox(height: 16),
              Text("Nombre: $name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Apellidos: $lastName", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text("Número de teléfono: $phoneNumber", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showEditPhoneDialog,
                child: Text("Editar teléfono"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Cerrar sesión"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
