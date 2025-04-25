import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/AuthProvider.dart';
// import '/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Тема приложения
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              title: const Text('Тёмная тема'),
              value: true,
              onChanged: (value) => (),
              // value: themeProvider.isDarkMode,
              // onChanged: (value) {
              //   themeProvider.toggleTheme();
              // },
              secondary: const Icon(Icons.brightness_6),
            ),
          ),

          const SizedBox(height: 16),

          // Язык приложения (заглушка)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Язык'),
              subtitle: const Text('Русский'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: реализовать смену языка
              },
            ),
          ),

          const SizedBox(height: 16),

          // Уведомления
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              title: const Text('Уведомления'),
              value: true,
              onChanged: (value) {
                // TODO: реализовать настройку уведомлений
              },
              secondary: const Icon(Icons.notifications_active),
            ),
          ),

          const SizedBox(height: 16),

          // Выход
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Выйти'),
              onTap: () {
                authProvider.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),

          const SizedBox(height: 16),

          // Версия приложения
          Center(
            child: Text(
              'Версия 1.0.0',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
