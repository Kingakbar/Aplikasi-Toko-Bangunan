import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:app_kasir_sitokba/service/transaksi_service.dart';
import 'package:app_kasir_sitokba/model/transaksi_model.dart';
import 'package:intl/intl.dart';

class PembayaranPage extends StatelessWidget {
  const PembayaranPage({Key? key});

  @override
  Widget build(BuildContext context) {
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
          } else if (snapshot.hasData) {
            final List<Transaksi> transaksiList = snapshot.data!;
            final List<Transaksi> transaksiSudahBayar = transaksiList
                .where((transaksi) => transaksi.status == 'belum_bayar')
                .toList();

            if (transaksiSudahBayar.isEmpty) {
              return Center(
                  child: Text(
                'Tidak ada transaksi yang Belum dibayar',
                style: blackTextStyle.copyWith(),
              ));
            }

            // Urutkan transaksiSudahBayar berdasarkan tanggal secara menurun
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
                            builder: (context) =>
                                DetailPembayaranPage(transaksi: transaksi),
                          ),
                        );
                      },
                      child: Text(
                        'Bayar Pembelian',
                        style: greenTextStyle.copyWith(),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}

class DetailPembayaranPage extends StatelessWidget {
  final Transaksi transaksi;

  const DetailPembayaranPage({Key? key, required this.transaksi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Detail Pembayaran',
          style: blackTextStyle.copyWith(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: 600,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('No Transaksi', transaksi.noTransaksi),
                _buildInfoRow('Tanggal Transaksi',
                    DateFormat('yyyy-MM-dd').format(transaksi.tglTransaksi)),
                _buildInfoRow('Subtotal', 'Rp ${transaksi.subtotal}'),
                _buildInfoRow('Total Akhir', 'Rp ${transaksi.totalAkhir}'),
                _buildInfoRow('Bayar', 'Rp ${transaksi.bayar}'),
                _buildInfoRow(
                    'id', '${transaksi.idTransaksi}'), // Menampilkan ID
                const Divider(),
                Text(
                  'Items Order',
                  style: blackTextStyle.copyWith(),
                ),
                for (var item in transaksi.transaksiDetail)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoRow('Nama Barang'),
                      Row(
                        children: [
                          _buildInfoRow(item.namaBarang),
                          const SizedBox(width: 10),
                          _buildInfoRow(item.banyak.toString(), 'x'),
                        ],
                      )
                    ],
                  ),
                const Spacer(),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: kPrimaryColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        _bayarBarang(context,
                            transaksi.idTransaksi); // Menggunakan ID transaksi
                      },
                      child: Text(
                        'Bayar Barang',
                        style: whiteTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _bayarBarang(BuildContext context, int idTransaksi) async {
    // Menggunakan tipe data int untuk ID transaksi
    try {
      await TransaksiService.updateStatus(idTransaksi.toString(),
          'sudah_bayar'); // Mengonversi ID menjadi string
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pembayaran berhasil'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PembayaranPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membayar: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildInfoRow(String title, [String? value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (value != null)
            Text(
              value,
              style: grayTextStyle.copyWith(
                fontSize: 16.0,
              ),
            ),
        ],
      ),
    );
  }
}
