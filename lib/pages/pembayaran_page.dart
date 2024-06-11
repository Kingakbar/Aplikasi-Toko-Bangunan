import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:app_kasir_sitokba/service/transaksi_service.dart';
import 'package:app_kasir_sitokba/model/transaksi_model.dart';
import 'package:intl/intl.dart';

class PembayaranPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Detail Pembayaran',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoRow('No Transaksi', transaksi.noTransaksi),
            _buildInfoRow('Tanggal Transaksi',
                DateFormat('yyyy-MM-dd').format(transaksi.tglTransaksi)),
            _buildInfoRow('Subtotal', 'Rp ${transaksi.subtotal}'),
            _buildInfoRow('Total Akhir', 'Rp ${transaksi.totalAkhir}'),
            _buildInfoRow('Bayar', 'Rp ${transaksi.bayar}'),
            const Divider(),
            const Text(
              'Items Order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transaksi.transaksiDetail.length,
              itemBuilder: (context, index) {
                var item = transaksi.transaksiDetail[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(item.namaBarang),
                      subtitle: Text(
                          'Harga: Rp ${item.harga}, Banyak: ${item.banyak}'),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (transaksi.gambar != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bukti Transaksi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Image.network(
                      'https://yohana.mra.my.id/storage/${transaksi.gambar}',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _bayarBarang(context, transaksi.idTransaksi),
                child: const Text('Bayar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _bayarBarang(BuildContext context, int idTransaksi) async {
    try {
      await TransaksiService.updateStatus(
          idTransaksi.toString(), 'sudah_bayar');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembayaran berhasil'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const PembayaranPage()),
        (route) => false,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membayar: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
