import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants/api.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class ProductService {

  static Future<bool> addProduct({
    required String title,
    required String newPrice,
    required String oldPrice,
    required String description,
    required String caliber,
    required String capacity,
    required String category,
    required String productType,
    required String productType2,
    required String length,
    required String model,
    required String weight,
    required String manufacturingCountry,
    required String manufacturingCompany,
    required String rating,
    required bool usage,
    required bool bestOffer,
    required List<XFile> images,
  }) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        Api.productStore
      ),
    );

    // البيانات
    request.fields['title'] = title;
    request.fields['new_price'] = newPrice;
    request.fields['old_price'] = oldPrice;
    request.fields['description'] = description;
    request.fields['caliber'] = caliber;
    request.fields['capacity'] = capacity;
    request.fields['category'] = category;
    request.fields['product_type'] = productType;
    request.fields['product_type2'] = productType2;
    request.fields['length'] = length;
    request.fields['model'] = model;
    request.fields['weight'] = weight;
    request.fields['manufacturing_countrey'] = manufacturingCountry;
    request.fields['manufacturing_company'] = manufacturingCompany;
    request.fields['rating'] = rating;
    request.fields['usage'] = usage ? "1" : "0";
    request.fields['best_offer'] = bestOffer ? "1" : "0";

    // الصور
    for (var image in images) {

      request.files.add(
        await http.MultipartFile.fromPath(
          'images[]',
          image.path,
        ),
      );
    }

    var response = await request.send();

    return response.statusCode == 200;
  }

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