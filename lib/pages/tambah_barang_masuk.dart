import 'package:app_kasir_sitokba/service/baran_api_service.dart';
import 'package:app_kasir_sitokba/service/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/model/barang_masuk_model.dart'
    as barang_masuk;
import 'package:app_kasir_sitokba/service/barang_masuk_service.dart';
import 'package:app_kasir_sitokba/model/barang_model.dart' as barang_model;
import 'package:app_kasir_sitokba/model/supplier_model.dart' as supplier_model;

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

  List<barang_model.Barang> _barangList = [];
  List<supplier_model.Supplier> _supplierList = [];
  barang_model.Barang? _selectedBarang;
  supplier_model.Supplier? _selectedSupplier;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      List<barang_model.Barang> barangList = await ApiService.fetchBarang();
      List<supplier_model.Supplier> supplierList =
          await ApiSupplierService.fetchSupplier();
      setState(() {
        _barangList = barangList;
        _supplierList = supplierList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void addBarangMasuk() async {
    if (_formKey.currentState!.validate()) {
      final int harga = int.parse(hargaController.text);
      final int jumlah = int.parse(jumlahController.text);
      final int totalHarga = harga * jumlah;

      final barangMasuk = barang_masuk.BarangMasuk(
        kdSupplier: kdSupplierController.text,
        kdBarang: kdBarangController.text,
        namaBarang: namaBarangController.text,
        satuan: satuanController.text,
        harga: harga,
        jumlah: jumlah,
        totalHarga: totalHarga,
        tanggal: tanggalController.text,
      );

      try {
        await BarangMasukService().addBarangMasuk(barangMasuk);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barang masuk berhasil ditambahkan'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushNamed(context, '/data-barang-masuk');
      } catch (e) {
        print('Error adding barang masuk: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        tanggalController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
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
              const SizedBox(height: 20),
              DropdownButtonFormField<barang_model.Barang>(
                value: _selectedBarang,
                onChanged: (barang_model.Barang? newValue) {
                  setState(() {
                    _selectedBarang = newValue;
                    kdBarangController.text = newValue?.kdBarang ?? '';
                    namaBarangController.text = newValue?.namaBarang ?? '';
                  });
                },
                validator: (value) => value == null ? 'Pilih barang' : null,
                items: _barangList.map((barang_model.Barang barang) {
                  return DropdownMenuItem<barang_model.Barang>(
                    value: barang,
                    child: Text(barang.namaBarang),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Pilih Barang',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<supplier_model.Supplier>(
                value: _selectedSupplier,
                onChanged: (supplier_model.Supplier? newValue) {
                  setState(() {
                    _selectedSupplier = newValue;
                    kdSupplierController.text = newValue?.kdSupplier ?? '';
                  });
                },
                validator: (value) => value == null ? 'Pilih supplier' : null,
                items: _supplierList.map((supplier_model.Supplier supplier) {
                  return DropdownMenuItem<supplier_model.Supplier>(
                    value: supplier,
                    child: Text(supplier.namaSupplier),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Pilih Supplier',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kdBarangController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode barang harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaBarangController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kdSupplierController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Kode Supplier',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode supplier harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: satuanController,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Satuan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty && jumlahController.text.isNotEmpty) {
                    final int harga = int.parse(value);
                    final int jumlah = int.parse(jumlahController.text);
                    final int totalHarga = harga * jumlah;
                    totalHargaController.text = totalHarga.toString();
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty && hargaController.text.isNotEmpty) {
                    final int harga = int.parse(hargaController.text);
                    final int jumlah = int.parse(value);
                    final int totalHarga = harga * jumlah;
                    totalHargaController.text = totalHarga.toString();
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: totalHargaController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Total Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total harga harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addBarangMasuk,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
