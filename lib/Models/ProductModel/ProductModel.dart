class ProductModel {
  final int id;
  final String name;
  final double energyKcal;

  ProductModel({
    required this.id,
    required this.name,
    required this.energyKcal,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      energyKcal: (json['energy_kcal'] as num).toDouble() / 100,
    );
  }
}