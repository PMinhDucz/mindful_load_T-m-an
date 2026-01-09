import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  String? _token;
  String? _userId;
  String? _fullName;
  String? _username;
  int _avatarIndex = 0; // Default avatar

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get username => _username;
  int get avatarIndex => _avatarIndex;

  bool _isFirstLogin = true;
  bool get isFirstLogin => _isFirstLogin;

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
      _username = extractedUserData['username'];
      _avatarIndex = extractedUserData['avatarIndex'] ?? 0; // Load avatar
      _isFirstLogin = false;
      notifyListeners();
    }
  }

  Future<void> setAvatar(int index) async {
    _avatarIndex = index;
    notifyListeners();
    // Persist
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final userData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      userData['avatarIndex'] = index;
      await prefs.setString('userData', json.encode(userData));
    }
    // Also save permanently for this user ID (survives logout)
    if (_userId != null) {
      await prefs.setInt('avatar_preference_$_userId', index);
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
      _username = responseData['user']['username'];

      // Load persistent avatar if exists
      final prefs = await SharedPreferences.getInstance();
      final avatarKey = 'avatar_preference_$_userId';
      if (prefs.containsKey(avatarKey)) {
        _avatarIndex = prefs.getInt(avatarKey) ?? 0;
      } else {
        _avatarIndex = 0;
      }

      // Check First Login
      final key = 'has_logged_in_$_userId';
      if (!prefs.containsKey(key)) {
        _isFirstLogin = true;
        await prefs.setBool(key, true);
      } else {
        _isFirstLogin = false;
      }

      notifyListeners();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'fullName': _fullName,
        'username': _username,
        'avatarIndex': _avatarIndex,
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
    _username = null;
    _avatarIndex = 0;
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
