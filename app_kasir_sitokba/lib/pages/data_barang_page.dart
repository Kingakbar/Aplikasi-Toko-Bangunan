import 'package:app_kasir_sitokba/model/barang_model.dart';
import 'package:app_kasir_sitokba/model/kategori_mode.dart';
import 'package:app_kasir_sitokba/service/baran_api_service.dart';
import 'package:app_kasir_sitokba/service/kategori_api_service.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';

class BarangPage extends StatefulWidget {
  // ignore: use_super_parameters
  const BarangPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  late Future<List<Barang>> futureBarang;
  late Future<List<Jenis>> futureJenis;

  String selectedJenis = '';
  String selectedKategori = '';

  @override
  void initState() {
    super.initState();
    futureBarang = ApiService.fetchBarang();
    futureJenis = ApiKategoriService.fetchJenis();
    futureJenis.then((jenis) {
      if (jenis.isNotEmpty) {
        setState(() {
          selectedJenis = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Daftar Barang'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home_page');
          },
        ),
      ),
      body: FutureBuilder<List<Barang>>(
        future: futureBarang,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('An error occurred!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                color: kWhiteColor,
                child: ListTile(
                  title: Text(snapshot.data![index].namaBarang),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stok Barang: ${snapshot.data![index].stok}', // Tampilkan kdBarang di sini
                        style: blackTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Harga Jual: Rp ${snapshot.data![index].hargaJual.toString()}',
                        style: blackTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Hapus Barang'),
                          content:
                              Text('Anda yakin ingin menghapus barang ini?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final deleted = await DeleteService.deleteData(
                                    snapshot.data![index].kdBarang);
                                if (deleted) {
                                  setState(() {
                                    futureBarang = ApiService.fetchBarang();
                                  });
                                  Navigator.pop(context); // Tutup dialog
                                }
                              },
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/add-barang');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
