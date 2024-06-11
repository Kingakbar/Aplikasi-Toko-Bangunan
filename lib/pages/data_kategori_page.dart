import 'package:app_kasir_sitokba/service/baran_api_service.dart';
import 'package:app_kasir_sitokba/service/kategori_api_service.dart';
import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:app_kasir_sitokba/model/kategori_mode.dart';

class KategoriPage extends StatefulWidget {
  // ignore: use_super_parameters
  const KategoriPage({Key? key}) : super(key: key);

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home_page');
          },
        ),
        title: Text(
          'Data Kategori',
          style: blackTextStyle.copyWith(),
        ),
      ),
      body: FutureBuilder<List<Jenis>>(
        future: ApiKategoriService.fetchJenis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            final List<Jenis> jenisList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: jenisList.length,
              itemBuilder: (context, index) {
                final Jenis jenis = jenisList[index];
                return Card(
                  color: kWhiteColor,
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      jenis.namaJenis,
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Kategori'),
                            content: const Text(
                              'Anda yakin ingin menghapus kategori ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (jenis.idJenis != null) {
                                    // Periksa apakah idJenis tidak null
                                    final deleted =
                                        await DeleteService.deleteJenis(
                                      jenis.idJenis!,
                                    );
                                    if (deleted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Kategori berhasil dihapus'),
                                        ),
                                      );
                                      setState(() {}); // Merefresh tampilan
                                    }
                                  }
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-kategori');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
