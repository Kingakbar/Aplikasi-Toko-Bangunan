import 'dart:convert';
import 'package:app_kasir_sitokba/model/detail_transaksi.dart';
import 'package:http/http.dart' as http;

class TransaksiDetailService {
  final String baseUrl = 'http://192.168.216.239:8080/api/detail_transaksi';

  Future<List<TransaksiDetail>> fetchTransaksiDetails(
      String noTransaksi) async {
    final response =
        await http.get(Uri.parse('$baseUrl?no_transaksi=$noTransaksi'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<TransaksiDetail> transaksiDetails =
          data.map((item) => TransaksiDetail.fromJson(item)).toList();
      return transaksiDetails;
    } else {
      throw Exception('Failed to load transaksi details');
    }
  }
}
