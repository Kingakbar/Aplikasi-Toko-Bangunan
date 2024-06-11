import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutApiService {
  static const String baseUrl = 'https://yohana.mra.my.id/api';

  static Future<bool> logout(String token) async {
    final url = Uri.parse('$baseUrl/logout');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> clearToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("token");
  }
}
