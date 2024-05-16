import 'package:flutter/foundation.dart';
import 'package:app_kasir_sitokba/service/auth_service.dart';
import 'package:app_kasir_sitokba/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _token;
  int? _id;

  final SharedPreferences _prefs;

  AuthProvider(this._prefs);

  UserModel? get user => _user;
  String? get token => _token;
  int? get id => _id;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  set token(String? token) {
    _token = token;
    _prefs.setString('token', token ?? '');
    notifyListeners();
  }

  set id(int? id) {
    _id = id;
    _prefs.setInt('id', id ?? 0);
    notifyListeners();
  }

  Future<bool> register({
    required String namaUser,
    required String jkUser,
    required String alamatUser,
    required String noTelpUser,
    required String username,
    required String password,
  }) async {
    try {
      _user = await AuthService().register(
        namaUser: namaUser,
        jkUser: jkUser,
        alamatUser: alamatUser,
        noTelpUser: noTelpUser,
        username: username,
        password: password,
      );

      if (_user != null) {
        _token = _user!.accessToken;
        _id = _user!.id;
      }

      notifyListeners();
      return true;
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }

  Future<void> saveCredentials(String username, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("savedUsername", username);
    await pref.setString("savedPassword", password);
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      _user = await AuthService().login(
        username: username,
        password: password,
      );

      if (_user != null) {
        _token = _user!.accessToken;
        _id = _user!.id;
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }

  // Future<bool> isLoggedIn() async {

  //   final String token = await getToken();
  //   if (token != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<String> getToken() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token').toString();
  // }
}
