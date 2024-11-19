import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:med_sync_app_movil/ui/daily_history_page.dart';
import 'package:med_sync_app_movil/ui/emergency_contact_page.dart';
import 'package:med_sync_app_movil/ui/home_page.dart';
import 'package:med_sync_app_movil/ui/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String lastName = "";
  String phoneNumber = "";
  String disease = "";
  double weight = 0.0;
  String token = ""; // Variable para almacenar el token
  int userId = 0; // Variable para almacenar el id del usuario

  @override
  void initState() {
    super.initState();
    _loadTokenAndUserId();
  }

  // Cargar el token y el id del usuario desde SharedPreferences y obtener los datos del paciente
  Future<void> _loadTokenAndUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedToken = prefs.getString('authToken') ?? "";
    int savedUserId = prefs.getInt('userId') ?? 0;

    setState(() {
      token = savedToken;
      userId = savedUserId;
    });

    if (token.isNotEmpty && userId != 0) {
      await _fetchPatientData();
    } else {
      print('Token o id de usuario no encontrado en SharedPreferences');
    }
  }

  // Método para obtener los datos del paciente desde la API usando el token y el id
  Future<void> _fetchPatientData() async {
    final url = Uri.parse('https://medsync-api.up.railway.app/api/v1/patients/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Usar el token en el encabezado
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? "";
          lastName = data['lastName'] ?? "";
          phoneNumber = data['phoneNumber'] ?? "";
          disease = data['disease'] ?? "";
          weight = (data['weight'] ?? 0).toDouble();
        });
      } else {
        print('Error al obtener los datos del paciente: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  // Método para actualizar los datos del paciente en el backend usando una solicitud PUT
  Future<void> _updatePatientData() async {
    final url = Uri.parse('http://192.168.56.1:8080/api/v1/patients/$userId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'disease': disease,
          'weight': weight,
        }),
      );

      if (response.statusCode == 200) {
        print('Datos actualizados correctamente');
      } else {
        print('Error al actualizar los datos: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud PUT: $e');
    }
  }

  void _showEditProfileDialog() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController lastNameController = TextEditingController(text: lastName);
    TextEditingController phoneNumberController = TextEditingController(text: phoneNumber);
    TextEditingController diseaseController = TextEditingController(text: disease);
    TextEditingController weightController = TextEditingController(text: weight.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Perfil"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                ),
                TextField(
                  controller: diseaseController,
                  decoration: InputDecoration(labelText: 'Enfermedad'),
                ),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Peso'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Guardar"),
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  lastName = lastNameController.text;
                  phoneNumber = phoneNumberController.text;
                  disease = diseaseController.text;
                  weight = double.tryParse(weightController.text) ?? weight;
                });

                _updatePatientData(); // Llama al método para actualizar los datos en el backend
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HeartRateMonitorPage()),
            );
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
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
              SizedBox(height: 16),
              Text("Nombre: $name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Apellidos: $lastName", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text("Teléfono: $phoneNumber", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text("Enfermedad: $disease", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text("Peso: $weight kg", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _showEditProfileDialog,
                    child: Text("Editar perfil"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContactPage()));
                    },
                    child: Text("Contacto Emergencia"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
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
