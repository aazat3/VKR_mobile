import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/AuthProvider.dart';
import '/Pages/HomePage.dart';
import '/Pages/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    final success = await Provider.of<AuthProvider>(context, listen: false)
        .login(_username.text, _password.text);
    setState(() => _loading = false);

    if (success) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный логин или пароль')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _loading ? null : _login, child: const Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: const Text("Нет аккаунта? Зарегистрироваться"),
            )
          ],
        ),
      ),
    );
  }
}