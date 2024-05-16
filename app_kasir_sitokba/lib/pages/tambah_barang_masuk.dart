import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/model/barang_masuk_model.dart';
import 'package:app_kasir_sitokba/service/barang_masuk_service.dart';

class AddBarangMasukPage extends StatefulWidget {
  const AddBarangMasukPage({Key? key}) : super(key: key);

  @override
  State<AddBarangMasukPage> createState() => _AddBarangMasukPageState();
}

class _AddBarangMasukPageState extends State<AddBarangMasukPage> {
  final TextEditingController kdSupplierController = TextEditingController();
  final TextEditingController kdBarangController = TextEditingController();
  final TextEditingController namaBarangController = TextEditingController();
  final TextEditingController satuanController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController totalHargaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void addBarangMasuk() async {
    if (_formKey.currentState!.validate()) {
      final barangMasuk = BarangMasuk(
        kdSupplier: kdSupplierController.text,
        kdBarang: kdBarangController.text,
        namaBarang: namaBarangController.text,
        satuan: satuanController.text,
        harga: int.parse(hargaController.text),
        jumlah: int.parse(jumlahController.text),
        totalHarga: int.parse(totalHargaController.text),
        tanggal: tanggalController.text,
      );

      try {
        await BarangMasukService().addBarangMasuk(barangMasuk);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barang masuk berhasil ditambahkan'),
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate to '/data-barang-masuk' page
        Navigator.pushNamed(context, '/data-barang-masuk');
      } catch (e) {
        // Handle error
        print('Error adding barang masuk: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang Masuk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: kdSupplierController,
                decoration: InputDecoration(labelText: 'Kode Supplier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode supplier harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: kdBarangController,
                decoration: InputDecoration(labelText: 'Kode Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode barang harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: namaBarangController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: satuanController,
                decoration: InputDecoration(labelText: 'Satuan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Satuan harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: jumlahController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: totalHargaController,
                decoration: InputDecoration(labelText: 'Total Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total harga harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addBarangMasuk,
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
