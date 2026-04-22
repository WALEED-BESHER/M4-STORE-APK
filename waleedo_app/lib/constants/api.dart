class Api {
  static const String ip = "192.168.1.2";
  static const String port = "80";

  // الرابط الأساسي
  static const String baseURL = "http://$ip:$port/api";

  // Endpoints
  static const String login = "$baseURL/login";
  static const String signup = "$baseURL/signup";
}