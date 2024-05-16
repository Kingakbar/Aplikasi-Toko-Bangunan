import 'package:app_kasir_sitokba/pages/barang_masuk_page.dart';
import 'package:app_kasir_sitokba/pages/data_barang_page.dart';
import 'package:app_kasir_sitokba/pages/data_kategori_page.dart';
import 'package:app_kasir_sitokba/pages/data_supplier.dart';
import 'package:app_kasir_sitokba/pages/home_page.dart';
import 'package:app_kasir_sitokba/pages/login_page.dart';
import 'package:app_kasir_sitokba/pages/pembayaran_page.dart';
import 'package:app_kasir_sitokba/pages/register_page.dart';
import 'package:app_kasir_sitokba/pages/splash_page.dart';
import 'package:app_kasir_sitokba/pages/tambah_barang_masuk.dart';
import 'package:app_kasir_sitokba/pages/tambah_data_barang_page.dart';
import 'package:app_kasir_sitokba/pages/tambah_data_supplier.dart';
import 'package:app_kasir_sitokba/pages/tambah_kategori.dart';
import 'package:app_kasir_sitokba/providers/auth_provider.dart';
import 'package:app_kasir_sitokba/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final prefs = snapshot.data!;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => AuthProvider(prefs),
              ),
              ChangeNotifierProvider(
                create: (context) => AuthService(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: {
                '/': (context) => const SplashPage(),
                '/login_page': (context) => const LoginPage(),
                '/home_page': (context) => const HomePage(),
                '/register': (context) => const RegisterPage(),
                '/data-barang': (context) => const BarangPage(),
                '/add-barang': (context) => const AddBarang(),
                '/data-kategori': (context) => const KategoriPage(),
                '/data-pembayaran': (context) => const PembayaranPage(),
                '/data-supplier': (context) => const SupplierPage(),
                '/data-barang-masuk': (context) => const BarangMasukPage(),
                '/tamabh-barang-masuk': (context) => const AddBarangMasukPage(),
                '/tambah-supplier': (context) => const AddSupplierPage(),
                '/tambah-kategori': (context) => AddKategoriForm(),
              },
            ),
          );
        }
        return const MaterialApp(
            home: Scaffold(body: CircularProgressIndicator()));
      },
    );
  }
}
