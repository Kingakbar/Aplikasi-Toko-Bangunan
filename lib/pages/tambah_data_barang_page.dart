import 'package:app_kasir_sitokba/model/kategori_mode.dart';
import 'package:app_kasir_sitokba/service/baran_api_service.dart';
import 'package:app_kasir_sitokba/service/kategori_api_service.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';

class AddBarang extends StatefulWidget {
  const AddBarang({Key? key}) : super(key: key);

  @override
  _AddBarangState createState() => _AddBarangState();
}

class _AddBarangState extends State<AddBarang> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController idJenisController = TextEditingController();
  final TextEditingController satuanController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaPokokController = TextEditingController();
  final TextEditingController markupController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();

  List<Jenis>? jenisBarang;

  @override
  void initState() {
    super.initState();
    fetchJenis();
  }

  Future<void> fetchJenis() async {
    try {
      final List<Jenis> result = await ApiKategoriService.fetchJenis();
      setState(() {
        jenisBarang = result;
      });
    } catch (e) {
      print('Failed to fetch jenis barang: $e');
    }
  }

  void calculateHargaJual() {
    final hargaPokok = int.tryParse(hargaPokokController.text) ?? 0;
    final markup = int.tryParse(markupController.text) ?? 0;
    final hargaJual = hargaPokok + (hargaPokok * markup / 100);
    hargaJualController.text = hargaJual.toStringAsFixed(0);
  }

  void postData() async {
    try {
      final Map<String, dynamic> data = {
        'nama_barang': namaController.text,
        'id_jenis': int.parse(idJenisController.text),
        'satuan': satuanController.text,
        'stok': int.parse(stokController.text),
        'harga_pokok': int.parse(hargaPokokController.text),
        'markup': int.parse(markupController.text),
        'harga_jual': int.parse(hargaJualController.text),
      };

      await ApiService().postData(data);

      Navigator.pushNamed(context, '/data-barang');
    } catch (e) {
      print('Gagal menambahkan data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kTranparantColor,
        title: Text(
          'Tambahkan Data Barang',
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          children: [
            formInput('Nama Barang', namaController),
            formInput('Jenis Barang', idJenisController,
                jenisBarang: jenisBarang),
            formInput('Satuan Barang', satuanController),
            formInput('Stok Barang', stokController),
            formInput('Harga', hargaPokokController,
                onChanged: calculateHargaJual),
            formInput('Markup', markupController,
                onChanged: calculateHargaJual, isPercentage: true),
            formInput('Harga Jual', hargaJualController, readOnly: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(56),
                  ),
                ),
                onPressed: postData,
                child: Center(
                  child: Text(
                    'Submit Data',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

Widget formInput(String labelText, TextEditingController controller,
    {List<Jenis>? jenisBarang,
    Function? onChanged,
    bool readOnly = false,
    bool isPercentage = false}) {
  if (labelText == 'Jenis Barang' && jenisBarang != null) {
    String? selectedValue = controller.text.isNotEmpty ? controller.text : null;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: blackTextStyle.copyWith(),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<Jenis>(
            value: jenisBarang.firstWhere(
                (jenis) => jenis.namaJenis == selectedValue,
                orElse: () => jenisBarang.first),
            onChanged: (newValue) {
              controller.text = newValue!.idJenis.toString();
            },
            items: jenisBarang.map((jenis) {
              return DropdownMenuItem<Jenis>(
                value: jenis,
                child: Text(jenis.namaJenis),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Pilih Jenis Barang',
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: blackTextStyle.copyWith(),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onChanged: (value) {
              if (onChanged != null) {
                onChanged();
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: isPercentage ? const Icon(Icons.percent) : null,
            ),
          ),
        ],
      ),
    );
  }
}
