import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import 'dart:io';
class UserService
{
  // جلب بيانات الحسابات
  static Future<List<Map<String,dynamic>>> getUsers() async{

    final response = await http.get(
      Uri.parse(
        Api.getusers
      ),
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return List<Map<String,dynamic>>.from(data["users"]);
    }
    return [];
  }
 // تفعيل + تعطيل الحسابات
  static Future<Map<String,dynamic>> toggleActivation(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
          Api.toggleActivation(userId),
        ),
      );
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        return {
          "success": true,
          "message": data["message"],
        };
      }
      return {
        "success": false,
        "message": data["message"] ?? "حدث خطأ غير معروف",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "فشل الاتصال بالسيرفر",
      };
    }
  }
  // رفع وسحب الادمن
  static Future<Map<String,dynamic>> toggleAdmin(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
          Api.toggleAdmin(userId),
        ),
      );
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        return {
          "success": true,
          "message": data["message"],
        };
      }
      return {
        "success": false,
        "message": data["message"] ?? "حدث خطأ غير معروف",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "فشل الاتصال بالسيرفر",
      };
    }
  }

  // حذف المستخدم من dashboard
  static Future<Map<String,dynamic>> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          Api.deleteUser(userId),
        ),
      );
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        
        return {
          "success": true,
          "message": data["message"],
        };
      }
      return {
        "success": false,
        "message": data["message"] ?? "فشل حذف المستخدم",
      };
    } catch(e){
      return {
        "success": false,
        "message": "خطأ: $e",
      };
    }
  }




}