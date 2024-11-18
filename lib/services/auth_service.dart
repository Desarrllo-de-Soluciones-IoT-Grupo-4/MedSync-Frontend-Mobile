import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://192.168.56.1:8080/api/v1';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en el inicio de sesión: ${response.body}');
    }
  }

  Future<void> register(Map<String, String> userData) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      // Registro exitoso: guarda el nombre del usuario en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userData['name'] ?? "Usuario");
    } else {
      throw Exception('Error en el registro: ${response.body}');
    }
  }

// Otros métodos...
}
