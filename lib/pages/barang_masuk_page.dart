import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/service/barang_masuk_service.dart';
import 'package:app_kasir_sitokba/model/barang_masuk_model.dart';
import 'package:intl/intl.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({Key? key}) : super(key: key);

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  final BarangMasukService _service = BarangMasukService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang Masuk'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home_page');
          },
        ),
      ),
      body: FutureBuilder<List<BarangMasuk>>(
        future: _service.fetchBarangMasuk(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final List<BarangMasuk> barangMasukList = snapshot.data!;
            return ListView.builder(
              itemCount: barangMasukList.length,
              itemBuilder: (context, index) {
                final barangMasuk = barangMasukList[index];
                final totalHargaFormatted = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp',
                ).format(barangMasuk.totalHarga);
                return Card(
                  color: kWhiteColor,
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(barangMasuk.namaBarang),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Supplier: ${barangMasuk.supplier?.namaSupplier ?? 'No Supplier'}'),
                        const SizedBox(height: 4),
                        Text('Jumlah: ${barangMasuk.jumlah}'),
                        const SizedBox(height: 4),
                        Text('Total Harga: $totalHargaFormatted'),
                      ],
                    ),
                    // You can add more details if needed
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Tidak ada data barang masuk'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/tamabh-barang-masuk');
        },
        child: Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
    );
  }
}
