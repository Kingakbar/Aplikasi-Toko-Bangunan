import 'dart:io';
import 'package:app_kasir_sitokba/model/bukti_transaksi.dart';
import 'package:app_kasir_sitokba/service/bukti_transaksi_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuktiTransaksiPage extends StatefulWidget {
  final String noTransaksi;
  const BuktiTransaksiPage({Key? key, required this.noTransaksi})
      : super(key: key);

  @override
  _BuktiTransaksiPageState createState() => _BuktiTransaksiPageState();
}

class _BuktiTransaksiPageState extends State<BuktiTransaksiPage> {
  final BuktiTransaksiService _service = BuktiTransaksiService();
  String _imagePath = '';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submit() async {
    final buktiTransaksi = BuktiTransaksi(
      noTransaksi: widget.noTransaksi,
    );

    try {
      // ignore: unused_local_variable
      final createdBuktiTransaksi =
          await _service.createBuktiTransaksi(buktiTransaksi, _imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bukti Transaksi berhasil disimpan')));

      // Navigate back to home page after successful submission
      Navigator.pushNamed(context, '/home_page');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan Bukti Transaksi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Transaksi'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Nomor Transaksi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              widget.noTransaksi,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20.0),
            _imagePath.isEmpty
                ? const Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(
                    width: 200, // Atur lebar gambar
                    height: 200, // Atur tinggi gambar
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(_imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _pickImage,
              child: const Text(
                'Pick Image',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submit,
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
