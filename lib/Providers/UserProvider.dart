import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/ApiList.dart';
import '/Models/UserModel/UserModel.dart';

class UserProvider extends ChangeNotifier {
  List<UserBean> _users = [];
  bool _isLoading = false;

  List<UserBean> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(APIS.user), headers: {"Accept": "application/json"});
      List jsonData = json.decode(response.body);
      _users = jsonData.map((item) => UserBean.fromJsonMap(item)).toList();
    } catch (e) {
      print("Ошибка: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
