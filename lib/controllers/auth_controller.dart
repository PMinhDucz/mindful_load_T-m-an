import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  String? _token;
  String? _userId;
  String? _fullName;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;

  String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api/auth';
    return 'http://localhost:3000/api/auth';
  }

  AuthController() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _fullName = extractedUserData['fullName'];
      notifyListeners();
    }
  }

  Future<void> register(
      String username, String password, String fullName) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'fullName': fullName,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode != 201) {
        throw HttpException(responseData['error']);
      }
      // Registration successful, usually redirect to Login
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(responseData['error'] ?? 'Login failed');
      }

      _token = responseData['token'];
      _userId = responseData['user']['id'].toString();
      _fullName = responseData['user']['fullName'];

      notifyListeners();

      // Save to Prefs
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'fullName': _fullName,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _fullName = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() {
    return message;
  }
}
