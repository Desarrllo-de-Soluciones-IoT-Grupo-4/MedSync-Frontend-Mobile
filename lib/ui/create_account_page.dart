import 'package:flutter/material.dart';
import 'package:med_sync_app_movil/services/auth_service.dart';
import 'package:med_sync_app_movil/ui/success_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores para cada campo de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final AuthService authService = AuthService();

  // Variable para almacenar el rol seleccionado
  String selectedRole = 'CARER'; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Número de teléfono',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // Dropdown para seleccionar el rol
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: [
                  DropdownMenuItem(
                    value: 'CARER',
                    child: Text('CARER'),
                  ),
                  DropdownMenuItem(
                    value: 'PATIENT',
                    child: Text('PATIENT'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Selecciona tu rol',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Llamada al método register con todos los datos, incluyendo "role"
                    await authService.register({
                      'name': nameController.text,
                      'lastname': lastNameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'role': selectedRole, // Usa el rol seleccionado
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessPage()),
                    );
                  } catch (e) {
                    print('Error en el registro: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Registrarse', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}