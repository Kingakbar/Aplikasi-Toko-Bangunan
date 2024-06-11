import 'dart:convert';
import 'package:app_kasir_sitokba/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static const String baseUrl = 'https://yohana.mra.my.id/api';

  static String? token;
  int? idUser;
  int? typeUser;

  Future<UserModel?> register({
    required String namaUser,
    required String jkUser,
    required String alamatUser,
    required String noTelpUser,
    required String username,
    required String password,
  }) async {
    final String apiUrl = '$baseUrl/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'nama_user': namaUser,
          'jk_user': jkUser,
          'alamat_user': alamatUser,
          'no_telp_user': noTelpUser,
          'username': username,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Data register: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final userJson = responseData['data']['user'];
        final tokenSaved = responseData['data']['access_token'];
        final typeUserSaved = responseData['data']['type_user'];

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("typeuser", typeUserSaved.toString());
        await pref.setString("token", tokenSaved);

        token = tokenSaved;
        print('Token saved: $tokenSaved');

        return UserModel.fromJson(userJson);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception('Failed to register user: ${errorData['message']}');
      }
    } catch (error) {
      throw Exception('Failed to register user: $error');
    }
  }

  Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    final String apiUrl = '$baseUrl/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        token = responseData['data']['access_token'];
        idUser = int.tryParse(responseData['data']['user']['id'].toString());
        typeUser =
            int.tryParse(responseData['data']['user']['type_user'].toString());

        print('Token saved: $token');
        print('Id saved: $idUser');
        print('TypeUser saved: $typeUser');

        final userJson = responseData['data']['user'];
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("token", token!);
        await pref.setString("userId", idUser.toString());
        await pref.setString("typeuser", typeUser.toString());
        await pref.setString("savedResponse", jsonEncode(responseData));

        return UserModel.fromJson(userJson);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception('Failed to login user: ${errorData['message']}');
      }
    } catch (error) {
      throw Exception('Failed to login user: $error');
    }
  }

  Map<String, String> get authHeader {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  void updateToken(String? newToken) {
    token = newToken;
  }
}
