import 'dart:convert';
import 'package:app_kasir_sitokba/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static const String baseUrl =
      'http://192.168.1.5:8080/api'; // Ganti dengan URL API Anda

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
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('data register: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final userJson = responseData['data']['user'];
      final tokenSaved = responseData['data']['access_token'];
      final typeUserSaved = responseData['data']['type_user'];
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("typeuser", typeUserSaved.toString());
      token = tokenSaved;
      print(tokenSaved);
      return UserModel.fromJson(userJson);
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    final String apiUrl = '$baseUrl/login';

    try {
      final response = await Dio().post(
        apiUrl,
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      Map obj = response.data;
      token = obj["data"]["access_token"];
      idUser = obj["data"]["user"]["id"];
      typeUser = obj["data"]["user"]["type_user"];

      print(response.data);

      if (response.statusCode == 200) {
        final tokensaved = token;
        final idSaved = idUser;
        final typeUserSaved = typeUser;
        print('Token saved: $tokensaved');
        print('Id saved: $idSaved');
        print('typeUser saved: $typeUserSaved');
        final Map<String, dynamic> responseData = response.data;
        final userJson = responseData['data']['user'];

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("token", tokensaved!);
        await pref.setString("userId", idSaved.toString());
        await pref.setString("typeuser", typeUserSaved.toString());
        await pref.setString("savedResponse",
            jsonEncode(response.data)); // Menyimpan seluruh response

        return UserModel.fromJson(userJson);
      } else {
        throw Exception('Failed to login user');
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

  // Method untuk mengupdate token
  void updateToken(String? newToken) {
    token = newToken;
  }
}
