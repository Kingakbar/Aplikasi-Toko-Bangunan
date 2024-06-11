import 'package:app_kasir_sitokba/model/kategori_mode.dart';
import 'package:app_kasir_sitokba/service/kategori_api_service.dart';
import 'package:flutter/material.dart';

class AddKategoriForm extends StatefulWidget {
  @override
  _AddKategoriFormState createState() => _AddKategoriFormState();
}

class _AddKategoriFormState extends State<AddKategoriForm> {
  final _formKey = GlobalKey<FormState>();
  late String _namaJenis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kategori'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kategori tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _namaJenis = value!;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _submitForm();
                    }
                  },
                  child: Text('Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Jenis kategori = Jenis(namaJenis: _namaJenis, idJenis: 0);
      try {
        // Tambahkan kategori menggunakan layanan API
        await ApiKategoriService.addkategori(kategori);

        // Sembunyikan indikator progress dan tampilkan pesan sukses
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kategori berhasil ditambahkan')),
        );

        // Reset formulir
        _formKey.currentState!.reset();

        // Kembali ke halaman kategori
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/data-kategori');
      } catch (e) {
        Navigator.popAndPushNamed(context, '/data-kategori');
      }
    }
  }
}
