// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:app_kasir_sitokba/model/transaksi_model.dart';
import 'package:http/http.dart' as http;

class TransaksiService {
  static const String apiUrl = 'https://yohana.mra.my.id/api/transaksi';

  static Future<List<Transaksi>> fetchBarang() async {
    final response = await http.get(Uri.parse('$apiUrl/barang'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Transaksi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> storeTransaksi(Transaksi transaksi) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(transaksi),
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final String no_transaksi = jsonResponse['data']['no_transaksi'];

      print(no_transaksi);

      if (response.statusCode == 201) {
        print('oke has');
        print('Transaksi berhasil disimpan');
      } else {
        print('Gagal menyimpan transaksi: ${response.body}');
        throw Exception('Gagal menyimpan transaksi');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Melempar kembali error untuk penanganan di lapisan yang lebih tinggi
    }
  }

  static Future<Transaksi> fetchTransaksiById(int no_transaksi) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$no_transaksi'));

      if (response.statusCode == 200) {
        return Transaksi.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  static Future<String?> updateStatus(String idTransaksi, String status) async {
    final String apiUrl =
        'https://yohana.mra.my.id/api/status_bayar/$idTransaksi';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> data = {
      'status': status,
    };

    final http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return 'Status transaksi berhasil diperbarui';
    } else {
      throw Exception(
          'Gagal memperbarui status transaksi: ${response.reasonPhrase}');
    }
  }

  static Future<String> updateGambar(String noTransaksi, File gambar) async {
    final String apiUrlWithTransaksi = '$apiUrl/$noTransaksi';

    // Create a multipart request
    var request = http.MultipartRequest('PUT', Uri.parse(apiUrlWithTransaksi));

    // Add the image file to the request
    var picture = await http.MultipartFile.fromPath('gambar', gambar.path);
    request.files.add(picture);

    // Add any headers if necessary
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      // If you need to parse the response, you can do it here
      return 'Gambar transaksi berhasil diperbarui';
    } else {
      throw Exception('Gagal memperbarui gambar transaksi');
    }
  }
}

class TransaksiDataService {
  static const String apiUrl = 'https://yohana.mra.my.id/api/transaksi';

  static Future<List<Transaksi>> fetchTransaksi() async {
    try {
      // ignore: unnecessary_string_interpolations
      final response = await http.get(Uri.parse('$apiUrl'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Transaksi.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
