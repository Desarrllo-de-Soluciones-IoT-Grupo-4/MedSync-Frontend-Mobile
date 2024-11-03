import 'package:flutter/material.dart';
import 'package:med_sync_app_movil/ui/daily_history_page.dart';
import 'package:med_sync_app_movil/ui/emergency_contact_page.dart';
import 'package:med_sync_app_movil/ui/home_page.dart';
import 'package:med_sync_app_movil/ui/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Esteban Lórax";
  String lastName = "Fernández Pasco";
  String address = "Avenida Siempreviva 777";
  String phone = "912345678";
  String email = "estebfer777@gmail.com";


  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(text: name);
        TextEditingController lastNameController = TextEditingController(text: lastName);
        TextEditingController addressController = TextEditingController(text: address);
        TextEditingController phoneController = TextEditingController(text: phone);
        TextEditingController emailController = TextEditingController(text: email);

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
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Dirección'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
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
                  address = addressController.text;
                  phone = phoneController.text;
                  email = emailController.text;
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
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HeartRateMonitorPage()));
          },
        ),
        title: Text("¡Hola, Esteban!"),
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
              Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(lastName, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text(address, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text(phone, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text(email, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EmergencyContactPage()));
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
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
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

