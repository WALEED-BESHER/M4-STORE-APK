import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants/api.dart';
class ProductService {

  static Future<List<Map<String,dynamic>>> getProducts() async {

    final response = await http.get(
      Uri.parse(
        Api.product
      ),
    );
    if(response.statusCode == 200){

      final data = jsonDecode(response.body);

      return List<Map<String,dynamic>>.from(data["data"]);
    }
    return [];
  }
}