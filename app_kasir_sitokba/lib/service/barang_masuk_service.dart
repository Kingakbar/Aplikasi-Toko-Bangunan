import 'dart:convert';
import 'package:app_kasir_sitokba/model/barang_masuk_model.dart';
import 'package:http/http.dart' as http;

class BarangMasukService {
  static const String baseUrl = 'http://192.168.216.239:8080/api';

  Future<List<BarangMasuk>> fetchBarangMasuk() async {
    final response = await http.get(Uri.parse('$baseUrl/barang_masuk'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((item) => BarangMasuk.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addBarangMasuk(BarangMasuk barangMasuk) async {
    final Map<String, dynamic> data = {
      'kd_supplier': barangMasuk.kdSupplier,
      'kd_barang': barangMasuk.kdBarang,
      'nama_barang': barangMasuk.namaBarang,
      'satuan': barangMasuk.satuan,
      'harga': barangMasuk.harga,
      'jumlah': barangMasuk.jumlah,
      'total_harga': barangMasuk.totalHarga,
      'tanggal': barangMasuk.tanggal,
      // You might need to adjust the data structure based on your API requirements
    };

    final response = await http.post(
      Uri.parse('$baseUrl/barang_masuk'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      // Data successfully added
    } else {
      throw Exception('Failed to add data');
    }
  }
}
