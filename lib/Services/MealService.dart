import 'package:flutter_application_1/ApiList.dart';
import '/Models/MealModel/MealModel.dart';
import '/Services/DioClient.dart';

class MealService {

  Future<List<MealModel>> fetchMeals() async {
    final response = await DioClient.dio.get(APIS.meal);//, headers: {"Authorization": "Bearer $token", "Accept": "application/json"}
    if (response.statusCode == 200) {
      // final List decoded = json.decode(utf8.decode(response.bodyBytes));
      final data = response.data as List;
      return data.map((item) => MealModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
