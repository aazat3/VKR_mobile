import 'package:flutter_application_1/ApiList.dart';
import '/Models/ProductModel/ProductModel.dart';
import '/Services/DioClient.dart';

class ProductService {

  Future<List<ProductModel>> fetchProducts() async {
    final response = await DioClient.dio.get(APIS.product);//, headers: {"Authorization": "Bearer $token", "Accept": "application/json"}
    if (response.statusCode == 200) {
      // final List decoded = json.decode(utf8.decode(response.bodyBytes));
      final data = response.data as List;
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
