class Api {
  static const String ip = "192.168.1.2";
  static const String port = "80";

  // الرابط الأساسي
  static const String baseURL = "http://$ip:$port/api";

  // Endpoints
  static const String login = "$baseURL/login";
  static const String signup = "$baseURL/signup";
  static const String sendOtp = "$baseURL/sendOtp";
  static const String verifyOtp = "$baseURL/verifyOtp";
  static const String profile = "$baseURL/profile";
  static const String updateProfile = "$baseURL/update-profile";
}