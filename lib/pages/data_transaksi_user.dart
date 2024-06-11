import 'package:app_kasir_sitokba/model/transaksi_model.dart';
import 'package:app_kasir_sitokba/pages/bayar_transaksi.dart';
import 'package:app_kasir_sitokba/service/transaksi_service.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_kasir_sitokba/providers/auth_provider.dart';

class DataTransaksiUser extends StatelessWidget {
  // ignore: use_super_parameters
  const DataTransaksiUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final int? userId = authProvider.id;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home_page');
          },
        ),
        title: Text(
          'Pembayaran User',
          style: blackTextStyle.copyWith(),
        ),
      ),
      body: FutureBuilder<List<Transaksi>>(
        future: TransaksiDataService.fetchTransaksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Kamu Belum Melakukan Transaksi Apapun',
                style: blackTextStyle.copyWith(),
              ),
            );
          } else {
            List<Transaksi> transaksiList = snapshot.data!;
            List<Transaksi> transaksiSudahBayar = transaksiList
                .where((transaksi) =>
                    transaksi.userId == userId &&
                    transaksi.status == 'belum_bayar')
                .toList();

            if (transaksiSudahBayar.isEmpty) {
              return Center(
                child: Text(
                  'Kamu Belum Melakukan Transaksi Apapun',
                  style: blackTextStyle.copyWith(),
                ),
              );
            }

            List<Transaksi> sortedTransaksi = transaksiSudahBayar.toList();
            sortedTransaksi
                .sort((a, b) => b.tglTransaksi.compareTo(a.tglTransaksi));

            return ListView.builder(
              itemCount: sortedTransaksi.length,
              itemBuilder: (context, index) {
                Transaksi transaksi = sortedTransaksi[index];
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      'No Transaksi: ${transaksi.noTransaksi}',
                      style: blackTextStyle.copyWith(),
                    ),
                    subtitle: Text('Atas Nama: ${transaksi.userName}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuktiTransaksiPage(
                                noTransaksi: transaksi.noTransaksi),
                          ),
                        );
                      },
                      child: Text(
                        'Kirim Bukti Transaksi',
                        style: greenTextStyle.copyWith(),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
