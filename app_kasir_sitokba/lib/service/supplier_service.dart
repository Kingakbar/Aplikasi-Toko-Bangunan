import 'dart:convert';

import 'package:app_kasir_sitokba/model/supplier_model.dart';
import 'package:http/http.dart' as http;

class ApiSupplierService {
  static const String baseUrl = 'http://192.168.216.239:8080/api';

  static Future<List<Supplier>> fetchSupplier() async {
    final response = await http.get(Uri.parse(baseUrl + '/supplier'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Supplier.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  static Future<void> addSupplier(Supplier supplier) async {
    final Map<String, dynamic> data = {
      'nama_supplier': supplier.namaSupplier,
      'alamat_supplier': supplier.alamatSupplier,
      'no_telp_supplier': supplier.noTelpSupplier,
    };

    final response = await http.post(
      Uri.parse(baseUrl + '/supplier'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print(response.body);
    } else {
      throw Exception('Failed to add supplier');
    }
  }
}
