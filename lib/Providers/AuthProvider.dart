import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/ApiList.dart';
import '/Models/UserModel/AuthResponse.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null;

  String get token => _token ?? '';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(APIS.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(json);
      _token = authResponse.token;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('users_access_token', _token!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse(APIS.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response.statusCode == 200;
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('users_access_token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('users_access_token')) {
      _token = prefs.getString('users_access_token');
      notifyListeners();
    }
  }
}
