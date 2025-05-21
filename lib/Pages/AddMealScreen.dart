import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Providers/MealProvider.dart';
import '../Providers/ProductProvider.dart';
import '../Models/ProductModel/ProductModel.dart';
import 'package:intl/intl.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  ProductModel? _selectedProduct;
  List<ProductModel> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isEmpty) {
        setState(() {
          _searchResults = [];
          _searchError = null;
        });
        return;
      }
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final results = await context.read<ProductProvider>().searchLoadProducts(
        name: query,
      );
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchError = e.toString();
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchDebounce?.cancel();
    _weightController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

Future<void> _saveMeal() async {
  if (!_formKey.currentState!.validate()) return;
  
  if (_selectedProduct == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Выберите продукт')),
    );
    return;
  }

  try {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    
    // Создаем DateTime с явным указанием UTC
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    ).toUtc();

    await mealProvider.addMeal(
      productID: _selectedProduct!.id, // Используем правильное имя параметра
      weight: int.parse(_weightController.text),
      time: dateTime,
    );

    Navigator.pop(context);
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceAll('Exception: ', '')),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить приём пищи'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveMeal),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSearchField(),
              const SizedBox(height: 16),
              _buildSearchResults(),
              const SizedBox(height: 20),
              _buildDateTimeSelection(),
              const SizedBox(height: 20),
              _buildWeightInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Поиск продукта',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _isSearching
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchError != null) {
      return Text(_searchError!, style: const TextStyle(color: Colors.red));
    }

    if (_searchController.text.isEmpty) {
      return const Text('Начните вводить название продукта');
    }

    if (_isSearching) {
      return const CircularProgressIndicator();
    }

    if (_searchResults.isEmpty) {
      return const Text('Продукты не найдены');
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.energyKcal} ккал/100г'),
            trailing:
                _selectedProduct?.id == product.id
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
            onTap: () => setState(() => _selectedProduct = product),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(DateFormat.yMd().format(_selectedDate)),
            onPressed: () => _selectDate(context),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.access_time),
            label: Text(_selectedTime.format(context)),
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }
Widget _buildWeightInput() {
  return TextFormField(
    controller: _weightController,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      labelText: 'Вес',
      suffixText: 'грамм',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Введите вес';
      final weight = int.tryParse(value);
      if (weight == null || weight <= 0) return 'Введите корректный вес';
      if (weight > 10000) return 'Максимальный вес 10 000г';
      return null;
    },
  );
}
}
