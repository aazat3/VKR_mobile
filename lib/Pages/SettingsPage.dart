import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/DeviceProvisioningPage.dart';
import 'package:flutter_application_1/Providers/GoalProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/AuthProvider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDeviceConnectionCard(context),
          const SizedBox(height: 16),
          _buildGoalCard(
            icon: Icons.local_fire_department,
            title: 'Калории',
            value: '${goalProvider.calories} ккал/день',
            onTap: () => _showCaloriesDialog(context),
          ),
          _buildGoalCard(
            icon: Icons.water_drop,
            title: 'Вода',
            value: '${goalProvider.water} мл/день',
            onTap: () => _showWaterDialog(context),
          ),
          _buildGoalCard(
            icon: Icons.food_bank,
            title: 'Соотношение БЖУ',
            value:
                '${goalProvider.proteinPercent}% / '
                '${goalProvider.fatPercent}% / '
                '${goalProvider.carbsPercent}%',
            onTap: () => _showMacrosDialog(context),
          ),

          const SizedBox(height: 16),
          // Тема приложения
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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

  Widget _buildDeviceConnectionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: const Icon(Icons.device_hub),
        title: const Text('Устройство ESP32'),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Для подключения устройства:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            '1. Включите устройство\n'
            '2. Убедитесь, что Bluetooth включен\n'
            '3. Нажмите "Найти устройство"',
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Найти устройство'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeviceProvisioningPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }

  void _showCaloriesDialog(BuildContext context) {
    final provider = Provider.of<GoalProvider>(context, listen: false);
    final controller = TextEditingController(
      text: provider.calories.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Дневная норма калорий'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: 'ккал/день'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  final value = int.tryParse(controller.text);
                  if (value != null && value > 0) {
                    provider.saveGoals({...provider.goals, 'calories': value});
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
    );
  }

  void _showWaterDialog(BuildContext context) {
    final provider = Provider.of<GoalProvider>(context, listen: false);
    final controller = TextEditingController(text: provider.water.toString());

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Норма воды'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: 'мл/день'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  final value = int.tryParse(controller.text);
                  if (value != null && value > 0) {
                    provider.saveGoals({...provider.goals, 'water': value});
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
    );
  }

  void _showMacrosDialog(BuildContext context) {
    final provider = Provider.of<GoalProvider>(context, listen: false);
    final controllers = {
      'protein': TextEditingController(
        text: provider.proteinPercent.toString(),
      ),
      'fat': TextEditingController(text: provider.fatPercent.toString()),
      'carbs': TextEditingController(text: provider.carbsPercent.toString()),
    };

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              void _validate() {
                final protein = int.tryParse(controllers['protein']!.text) ?? 0;
                final fat = int.tryParse(controllers['fat']!.text) ?? 0;
                final carbs = int.tryParse(controllers['carbs']!.text) ?? 0;
                setState(() {});
              }

              return AlertDialog(
                title: const Text('Соотношение БЖУ'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMacroInput(
                      'Белки',
                      controllers['protein']!,
                      _validate,
                    ),
                    _buildMacroInput('Жиры', controllers['fat']!, _validate),
                    _buildMacroInput(
                      'Углеводы',
                      controllers['carbs']!,
                      _validate,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Сумма: ${_currentSum(controllers)}%',
                      style: TextStyle(
                        color:
                            _currentSum(controllers) == 100
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed:
                        _currentSum(controllers) == 100
                            ? () {
                              provider.saveGoals({
                                ...provider.goals,
                                'protein': int.parse(
                                  controllers['protein']!.text,
                                ),
                                'fat': int.parse(controllers['fat']!.text),
                                'carbs': int.parse(controllers['carbs']!.text),
                              });
                              Navigator.pop(context);
                            }
                            : null,
                    child: const Text('Сохранить'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildMacroInput(
    String label,
    TextEditingController controller,
    VoidCallback onChanged,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: (value) => onChanged(),
    );
  }

  int _currentSum(Map<String, TextEditingController> controllers) {
    return controllers.values.fold(
      0,
      (sum, c) => sum + (int.tryParse(c.text) ?? 0),
    );
  }
}
