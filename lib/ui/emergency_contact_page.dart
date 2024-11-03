import 'package:flutter/material.dart';

class EmergencyContactPage extends StatefulWidget {
  @override
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  bool isEditing = false;
  final TextEditingController phoneController = TextEditingController(text: "912345678");
  final TextEditingController firstNameController = TextEditingController(text: "Esteban");
  final TextEditingController lastNameController = TextEditingController(text: "Lórax");
  final TextEditingController middleNameController = TextEditingController(text: "Fernández");
  final TextEditingController emailController = TextEditingController(text: "esteban@example.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacto Emergencia"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              enabled: isEditing,
              decoration: InputDecoration(labelText: "Número de teléfono"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: firstNameController,
              enabled: isEditing,
              decoration: InputDecoration(labelText: "Primer Nombre"),
            ),
            TextField(
              controller: middleNameController,
              enabled: isEditing,
              decoration: InputDecoration(labelText: "Apellido paterno"),
            ),
            TextField(
              controller: lastNameController,
              enabled: isEditing,
              decoration: InputDecoration(labelText: "Apellido materno"),
            ),
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: InputDecoration(labelText: "Correo"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                  }
                  isEditing = !isEditing;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(isEditing ? "Guardar datos" : "Editar"),
            ),
          ],
        ),
      ),
    );
  }
}
