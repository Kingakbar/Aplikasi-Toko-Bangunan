import 'package:app_kasir_sitokba/service/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/model/supplier_model.dart';

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({Key? key}) : super(key: key);

  @override
  _AddSupplierPageState createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  final TextEditingController namaSupplierController = TextEditingController();
  final TextEditingController alamatSupplierController =
      TextEditingController();
  final TextEditingController noTelpSupplierController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void addSupplier() async {
    if (_formKey.currentState!.validate()) {
      final supplier = Supplier(
        namaSupplier: namaSupplierController.text,
        alamatSupplier: alamatSupplierController.text,
        noTelpSupplier: noTelpSupplierController.text,
      );

      try {
        await ApiSupplierService.addSupplier(supplier);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supplier added successfully')),
        );

        // Navigate back or to the desired page
        Navigator.pushReplacementNamed(context, '/data-supplier');
      } catch (e) {
        // Handle error
        print('Error adding supplier: $e');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add supplier')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Supplier'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaSupplierController,
                decoration: InputDecoration(labelText: 'Nama Supplier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama supplier harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: alamatSupplierController,
                decoration: InputDecoration(labelText: 'Alamat Supplier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat supplier harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: noTelpSupplierController,
                decoration: InputDecoration(labelText: 'No. Telepon Supplier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No. telepon supplier harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addSupplier,
                child: Text('Tambah Supplier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
