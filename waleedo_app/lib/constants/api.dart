class Api {
  static const String ip = "192.168.1.2";
  static const String port = "80";

  // الرابط الأساسي
  static const String baseURL = "http://$ip:$port/api"; //mbeshr336@gmail.com  $Tata772701$

  // Endpoints http://192.168.1.5:80/api/profile
  static const String login = "$baseURL/login";
  static const String signup = "$baseURL/signup";
  static const String logout = "$baseURL/logout";
  static const String sendOtp = "$baseURL/sendOtp";
  static const String verifyOtp = "$baseURL/verifyOtp";
  static const String checkemail = "$baseURL/checkemail";
  static const String resetPassword = "$baseURL/forget-password";

  static const String profile = "$baseURL/profile";
  static const String updateProfile = "$baseURL/update-profile";
  
  static const String product = "$baseURL/products";
  static String deleteProduct(int id) => "$baseURL/products/$id";
  static const String productStore = "$baseURL/products/store";
  static String updateProduct(int id) => "$baseURL/products/update/$id";

  static const String getusers = "$baseURL/admin/users";
  static String toggleActivation(int id) {
    return "$baseURL/admin/users/$id/toggle-activation";
  }
  static String toggleAdmin(int id) {
    return "$baseURL/admin/users/$id/toggle-Admin";
  }
  static String deleteUser(int userId) => "$baseURL/admin/users/$userId";
  
  static const String toggleFavorites = "$baseURL/favorites/toggle";
  static const String changepassword = "$baseURL/change-password";
  static const String completeInformation = "$baseURL/complete-information";
}