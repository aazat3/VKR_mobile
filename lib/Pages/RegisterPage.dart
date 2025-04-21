import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/AuthProvider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _register() async {
    final success = await Provider.of<AuthProvider>(context, listen: false)
        .register(_username.text, _password.text);

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Успешно! Войдите.')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ошибка регистрации')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Зарегистрироваться')),
          ],
        ),
      ),
    );
  }
}
