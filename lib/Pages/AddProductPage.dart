import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/ProductModel/ProductModel.dart';
import 'package:flutter_application_1/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  int _categoryID = 1;
  int _sourceTypeId = 3; // 3 — личный, 2 — публичный
  double _energyKcal = 0;
  double _fatPercent = 0;
  double _proteinPercent = 0;
  double _carbohydratesPercent = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadCategories();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final newProduct = ProductModel(
        id: 0,
        name: _name,
        categoryID: _categoryID,
        sourceTypeId: _sourceTypeId,
        energyKcal: _energyKcal,
        fatPercent: _fatPercent,
        proteinPercent: _proteinPercent,
        carbohydratesPercent: _carbohydratesPercent,
      );

      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).addProduct(newProduct);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Продукт добавлен')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Добавить продукт')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Название',
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Введите название'
                                    : null,
                        onSaved: (val) => _name = val!,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Категория',
                        ),
                        value: _categoryID,
                        items: List.generate(categories.length, (index) {
                          return DropdownMenuItem(
                            value: categories[index].id,
                            child: Text(categories[index].name),
                          );
                        }),
                        onChanged:
                            (val) => setState(() => _categoryID = val ?? 1),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Тип источника',
                        ),
                        value: _sourceTypeId,
                        items: const [
                          DropdownMenuItem(value: 3, child: Text('Личный')),
                          DropdownMenuItem(value: 2, child: Text('Публичный')),
                        ],
                        onChanged:
                            (val) => setState(() => _sourceTypeId = val ?? 3),
                      ),
                      const SizedBox(height: 16),
                      _buildNumberField(
                        label: 'Калории (ккал)',
                        onSaved:
                            (val) => _energyKcal = double.tryParse(val!) ?? 0,
                      ),
                      _buildNumberField(
                        label: 'Жиры (%)',
                        onSaved:
                            (val) => _fatPercent = double.tryParse(val!) ?? 0,
                      ),
                      _buildNumberField(
                        label: 'Белки (%)',
                        onSaved:
                            (val) =>
                                _proteinPercent = double.tryParse(val!) ?? 0,
                      ),
                      _buildNumberField(
                        label: 'Углеводы (%)',
                        onSaved:
                            (val) =>
                                _carbohydratesPercent =
                                    double.tryParse(val!) ?? 0,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Добавить',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (val) {
          final number = double.tryParse(val ?? '');
          if (number == null || number < 0) return 'Введите корректное число';
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
