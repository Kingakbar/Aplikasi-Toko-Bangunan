import 'dart:convert';

import 'package:app_kasir_sitokba/model/barang_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.216.239:8080/api';

  static Future<List<Barang>> fetchBarang() async {
    final response = await http.get(Uri.parse('$baseUrl/barang'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Barang.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Barang?> postData(Map<String, dynamic> data) async {
    final url = Uri.parse(
        'http://192.168.216.239:8080/api/barang'); // Ganti URL sesuai dengan endpoint API Anda
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      print(response.body);
      if (response.statusCode == 201) {
        return Barang.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to post data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error posting data: $e');
      return null;
    }
  }
}

class DeleteService {
  static const String baseUrl = 'http://192.168.216.239:8080/api';

  static Future<bool> deleteData(String kdBarang) async {
    final url = Uri.parse(
        '$baseUrl/barang/$kdBarang'); // Menggunakan kdBarang dalam URL
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true; // Data berhasil dihapus
      } else {
        print('Failed to delete data: ${response.statusCode}');
        return false; // Gagal menghapus data
      }
    } catch (e) {
      print('Error deleting data: $e');
      return false; // Gagal menghapus data
    }
  }

  static Future<bool> deleteJenis(int idJenis) async {
    final url = Uri.parse('$baseUrl/jenis_barang/$idJenis');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return true; // Berhasil menghapus
      } else {
        print('Failed to delete data: ${response.statusCode}');
        return false; // Gagal menghapus
      }
    } catch (e) {
      print('Error deleting data: $e');
      return false; // Gagal menghapus
    }
  }
}
