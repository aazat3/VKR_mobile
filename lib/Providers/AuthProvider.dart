import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/ApiList.dart';
import '/Models/UserModel/AuthResponse.dart';
import '/Providers/DioClient.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null;

  String get token => _token ?? '';

  Future<bool> login(String email, String password) async {
    final response = await DioClient.dio.post(
      (APIS.login),
      data: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(response.data);
      _token = authResponse.token;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('users_access_token', _token!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    final response = await DioClient.dio.post(
      (APIS.register),
      data: jsonEncode({'email': email, 'password': password}),
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
