import 'dart:convert';
import 'package:app_kasir_sitokba/pages/success_page.dart';
import 'package:app_kasir_sitokba/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:app_kasir_sitokba/model/barang_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  final List<Barang> cartItems;
  final Function(List<Barang>) onUpdateCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onUpdateCart,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Map<String, Barang> _cartItems;
  final double _discountPercentage = 0.0;
  late String _transactionNumber;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _cartItems = {};
    for (Barang barang in widget.cartItems) {
      _cartItems[barang.namaBarang] = barang;
    }
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _transactionNumber =
        await _generateTransactionNumber(authProvider.user?.id ?? 0);
  }

  void _updateQuantity(String itemName, int newQuantity) {
    setState(() {
      _cartItems[itemName]!.quantity = newQuantity;
    });
    widget.onUpdateCart(_cartItems.values.toList());
  }

  void _removeItem(String itemName) {
    setState(() {
      _cartItems.remove(itemName);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName removed from cart'),
        duration: const Duration(seconds: 1),
      ),
    );
    widget.onUpdateCart(_cartItems.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    final totalHarga = _cartItems.values
        .fold<int>(0, (prev, item) => prev + (item.hargaJual * item.quantity));
    final diskon = totalHarga * (_discountPercentage / 100);
    final totalHargaSetelahDiskon = totalHarga - diskon;
    final totalHargaFormatted =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
            .format(totalHargaSetelahDiskon);
    final subtotalFormatted =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
            .format(totalHarga);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(
          'Checkout Barang',
          style: blackTextStyle.copyWith(),
        ),
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Text(
                'No items in cart',
                style: blackTextStyle.copyWith(fontSize: 18),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Text(
                    'Items Order',
                    style:
                        blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final itemName = _cartItems.keys.elementAt(index);
                      final item = _cartItems[itemName]!;
                      final quantity = item.quantity;
                      final totalHargaItem = item.hargaJual * quantity;
                      final totalHargaItemFormatted = NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                          .format(totalHargaItem);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.namaBarang} (${item.kdBarang})',
                                    style:
                                        blackTextStyle.copyWith(fontSize: 11),
                                  ),
                                  Text(
                                    totalHargaItemFormatted,
                                    style: grayTextStyle.copyWith(
                                        fontSize: 19, fontWeight: medium),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) {
                                        _updateQuantity(itemName, quantity - 1);
                                      }
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    ' $quantity x',
                                    style: greenTextStyle.copyWith(
                                        fontSize: 14, fontWeight: bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _updateQuantity(itemName, quantity + 1);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _removeItem(itemName);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTotalRow('Subtotal:', subtotalFormatted),
                        const SizedBox(height: 10),
                        _buildTotalRow('Total Harga:', totalHargaFormatted),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(56)),
                            ),
                            onPressed: () {
                              _bayar();
                            },
                            child: Text(
                              'Bayar',
                              style: whiteTextStyle.copyWith(
                                  fontSize: 16, fontWeight: semiBold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: blackTextStyle.copyWith(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: blackTextStyle.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  void _bayar() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.user == null) {
        // Handle case when user is null, maybe show an error message or return
        return;
      }

      final totalHarga = _cartItems.values.fold<int>(
          0, (prev, item) => prev + (item.hargaJual * item.quantity));
      final diskon = totalHarga * (_discountPercentage / 100);
      final totalHargaSetelahDiskon = totalHarga - diskon;

      final response = await http.post(
        Uri.parse('https://yohana.mra.my.id/api/transaksi'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'no_transaksi': _transactionNumber,
          'tgl_transaksi': DateTime.now().toString(),
          'subtotal': totalHargaSetelahDiskon,
          'diskon': 0,
          'total_akhir': totalHarga,
          'bayar': totalHargaSetelahDiskon,
          'kembalian': 0,
          'user_id': authProvider
              .user?.id, // Menggunakan ID pengguna yang sedang login
        }),
      );

      if (response.statusCode == 201) {
        print('Transaksi berhasil disimpan');
        await _kirimDetailBarang();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SuccessPage(noTransaksi: _transactionNumber)),
        );
      } else {
        print('Gagal menyimpan transaksi: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _kirimDetailBarang() async {
    try {
      for (Barang barang in _cartItems.values) {
        final response = await http.post(
          Uri.parse('https://yohana.mra.my.id/api/detail_transaksi'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'kd_barang': barang.kdBarang,
            'barang': barang.namaBarang,
            'harga': barang.hargaJual,
            'banyak': barang.quantity,
            'total': barang.hargaJual * barang.quantity,
          }),
        );

        if (response.statusCode == 201) {
          print('Detail barang berhasil disimpan');
        } else {
          print('Gagal menyimpan detail barang: ${response.body}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> _generateTransactionNumber(int userId) async {
    final formattedDate = DateFormat('ddMMyyyy').format(DateTime.now());

    final lastNumber =
        _prefs.getInt('last_transaction_number_$formattedDate') ?? 0;
    final newNumber = lastNumber + 1;
    _prefs.setInt('last_transaction_number_$formattedDate', newNumber);

    final transactionNumber =
        '$formattedDate${newNumber.toString().padLeft(3, '0')}-$userId';
    return transactionNumber;
  }
}
