import 'dart:convert';
import 'package:app_kasir_sitokba/model/kategori_mode.dart';
import 'package:http/http.dart' as http;

class ApiKategoriService {
  static const String baseUrl = 'http://192.168.216.239:8080/api';

  static Future<List<Jenis>> fetchJenis() async {
    final response = await http.get(Uri.parse('$baseUrl/jenis_barang'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Jenis.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<void> addkategori(Jenis kategori) async {
    final Map<String, dynamic> data = {
      'nama_jenis': kategori.namaJenis,
    };

    final response = await http.post(
      Uri.parse(baseUrl + '/jenis_barang'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print(response.body);
    } else {
      throw Exception('Failed to add Kategory');
    }
  }
}
