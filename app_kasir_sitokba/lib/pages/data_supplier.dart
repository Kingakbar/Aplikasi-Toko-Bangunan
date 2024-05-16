import 'package:app_kasir_sitokba/model/supplier_model.dart';
import 'package:app_kasir_sitokba/service/supplier_service.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Data Supplier',
          style: blackTextStyle.copyWith(),
        ),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: ApiSupplierService.fetchSupplier(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Supplier> suppliers = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                Supplier supplier = suppliers[index];
                return GestureDetector(
                  onTap: () {
                    // Implementasi aksi ketika item diklik (jika diperlukan)
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Supplier: ${supplier.namaSupplier}',
                            style: blackTextStyle.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Alamat: ${supplier.alamatSupplier}',
                            style: blackTextStyle.copyWith(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No. Telp: ${supplier.noTelpSupplier}',
                            style: blackTextStyle.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-supplier');
        },
        child: Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
    );
  }
}
