import 'dart:convert';
import 'package:app_kasir_sitokba/model/bukti_transaksi.dart';
import 'package:http/http.dart' as http;

class BuktiTransaksiService {
  final String baseUrl = 'https://yohana.mra.my.id/api';

  Future<BuktiTransaksi?> createBuktiTransaksi(
      BuktiTransaksi buktiTransaksi, String imagePath) async {
    final url = Uri.parse('$baseUrl/bukti_bayar');
    final request = http.MultipartRequest('POST', url)
      ..fields['no_transaksi'] = buktiTransaksi.noTransaksi;

    if (imagePath.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('gambar', imagePath);
      request.files.add(imageFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return BuktiTransaksi.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create BuktiTransaksi');
    }
  }
}
