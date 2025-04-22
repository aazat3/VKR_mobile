class MealModel {
  final int id;
  final int userId;
  final int productId;
  final int weight;
  final DateTime time;

  MealModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.weight,
    required this.time,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      userId: json['userID'],
      productId: json['productID'],
      weight: json['weight'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userId,
      'productID': productId,
      'weight': weight,
      'time': time.toIso8601String(),
    };
  }
}