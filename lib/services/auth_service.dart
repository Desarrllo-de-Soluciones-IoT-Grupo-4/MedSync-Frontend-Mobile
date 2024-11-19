import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:convert';

class AuthService {
  final String baseUrl = 'https://medsync-api.up.railway.app/api/v1';

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Respuesta de la API de inicio de sesión: $data"); // Imprime la respuesta en la consola

      String token = data['token']; // Obtén el token de la respuesta

      // Guarda el token en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      // Decodifica el token JWT para obtener el id del usuario
      final jwt = JWT.decode(token);
      final userId = jwt.payload['id']; // Ajusta 'id' según el nombre del campo en el payload

      print("ID del usuario decodificado: $userId"); // Imprime el id del usuario en la consola

      // Guarda el id en SharedPreferences
      await prefs.setInt('userId', userId);
    } else {
      print("Error en el inicio de sesión: ${response.body}"); // Imprime el error en la consola
      throw Exception('Error en el inicio de sesión: ${response.body}');
    }
  }

  // Método para registrarse
  Future<void> register(String name, String lastName, String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'lastname': lastName,
        'email': email,
        'password': password,
        'role': role, // "CARER" o "PATIENT"
      }),
    );

    if (response.statusCode == 200) {
      print("Registro exitoso: ${response.body}"); // Imprime la respuesta del registro en la consola
    } else {
      print("Error en el registro: ${response.body}"); // Imprime el error en la consola
      throw Exception('Error en el registro: ${response.body}');
    }
  }
}