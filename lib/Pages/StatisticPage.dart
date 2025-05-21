import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/ProductModel/ProductModel.dart';
import 'package:flutter_application_1/Pages/AddMealScreen.dart';
import 'package:flutter_application_1/Pages/ProductDetailScreen.dart';
import 'package:flutter_application_1/View/MealCard.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/Providers/MealProvider.dart';
import '/Models/MealModel/MealModel.dart';
import 'package:flutter_application_1/Providers/CategoryProvider.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    mealProvider.loadMeals(
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: mealProvider.endDate,
    );
    categoryProvider.loadCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('История питания'),
      actions: [
        IconButton(icon: const Icon(Icons.tune), onPressed: _showFilterModal),
      ],
    );
  }

  Widget _buildBody() {
    // final mealProvider = Provider.of<MealProvider>(context);
    return Consumer<MealProvider>(
      builder: (context, mealProvider, _) {
        if (mealProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (provider.error != null) {
        //   return Center(child: Text('Ошибка: ${provider.error}'));
        // }

        // if (provider.products.isEmpty) {
        //   return _buildEmptyState();
        // }

        return RefreshIndicator(
          onRefresh:
              () => mealProvider.loadMeals(
                startDate: mealProvider.startDate,
                endDate: mealProvider.endDate,
              ),
          child: CustomScrollView(
            slivers: [
              _buildSearchField(),
              _buildDateHeader(),
              _buildMealList(),
            ],
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _buildSearchField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _searchController,
          onChanged:
              (value) => Provider.of<MealProvider>(
                context,
                listen: false,
              ).setSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Поиск по приемам пищи...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildDateHeader() {
    final mealProvider = Provider.of<MealProvider>(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat(
                'd MMMM y',
              ).format(mealProvider.startDate ?? DateTime.now().subtract(const Duration(days: 7))),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward, size: 20),
            Text(
              DateFormat(
                'd MMMM y',
              ).format(mealProvider.endDate ?? DateTime.now()),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealList() {
    final mealProvider = Provider.of<MealProvider>(context);
    final groupedMeals = _groupMealsByDate(mealProvider.filteredMeals);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final date = groupedMeals.keys.elementAt(index);
        final meals = groupedMeals[date]!;

        return _buildDateGroup(date, meals);
      }, childCount: groupedMeals.keys.length),
    );
  }

  Widget _buildDateGroup(String date, List<MealModel> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            DateFormat('EEEE, d MMM').format(DateTime.parse(date)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        // ...meals.map((meal) => _buildMealCard(meal)).toList(),
        ...meals.map((meal) => MealCard(meal: meal)).toList(),
      ],
    );
  }

  Widget _buildMealCard(MealModel meal) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProductDetails(meal.product!),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMealTypeIcon('breakfast'),
                  const SizedBox(width: 12),
                  Text(
                    meal.time.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    '${meal.product!.energyKcal} ккал',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (meal.product != null) _buildProductItem(meal.product!),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(product.name)),
          Text(
            '${product.energyKcal} ккал',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeIcon(String type) {
    final icons = {
      'breakfast': Icons.breakfast_dining,
      'lunch': Icons.lunch_dining,
      'dinner': Icons.dinner_dining,
      'snack': Icons.local_cafe,
    };

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icons[type] ?? Icons.restaurant,
        size: 20,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      heroTag: 'add_meal',
      onPressed: _navigateToAddMeal,
      backgroundColor: Colors.teal,
      child: const Icon(Icons.restaurant, color: Colors.white),
    );
  }

  void _navigateToAddMeal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMealScreen()),
    ).then((_) {
      Provider.of<MealProvider>(context, listen: false).loadMeals();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterContent(),
    );
  }

  Widget _buildFilterContent() {
    final mealProvider = Provider.of<MealProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterSectionHeader('Категории'),
          Wrap(
            spacing: 8,
            children: [
              _buildCategoryChip('Все', mealProvider.selectedCategory == null),
              ...categoryProvider.categories.map(
                (c) => _buildCategoryChip(
                  c.name,
                  mealProvider.selectedCategory == c.name,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterSectionHeader('Дата'),
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: const Text('Выбрать период'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool selected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected:
          (value) => Provider.of<MealProvider>(
            context,
            listen: false,
          ).setCategoryFilter(value ? label : null),
      selectedColor: Colors.blue,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(0),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: mealProvider.startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end:
            mealProvider.endDate ??
            DateTime.now(),
      ),
    );

    if (picked != null) {
      mealProvider.loadMeals(startDate: picked.start, endDate: picked.end);
    }
  }

  Map<String, List<MealModel>> _groupMealsByDate(List<MealModel> meals) {
    final grouped = <String, List<MealModel>>{};
    for (final meal in meals) {
      final dateKey = DateFormat('yyyy-MM-dd').format(meal.time);
      grouped.putIfAbsent(dateKey, () => []).add(meal);
    }
    return grouped;
  }
}
