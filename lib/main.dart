import 'dart:io';
import 'package:app_kasir_sitokba/pages/data_transaksi_user.dart';
import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/pages/barang_masuk_page.dart';
import 'package:app_kasir_sitokba/pages/bayar_transaksi.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient httpClient = super.createHttpClient(context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
              initialRoute: '/',
              onGenerateRoute: (settings) {
                if (settings.name == '/bayar-transaksi') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) {
                      return BuktiTransaksiPage(
                        noTransaksi: args['noTransaksi'],
                      );
                    },
                  );
                }
                // Default case for other routes
                switch (settings.name) {
                  case '/':
                    return MaterialPageRoute(
                        builder: (context) => const SplashPage());
                  case '/login_page':
                    return MaterialPageRoute(
                        builder: (context) => const LoginPage());
                  case '/home_page':
                    return MaterialPageRoute(
                        builder: (context) => const HomePage());
                  case '/register':
                    return MaterialPageRoute(
                        builder: (context) => const RegisterPage());
                  case '/data-barang':
                    return MaterialPageRoute(
                        builder: (context) => const BarangPage());
                  case '/add-barang':
                    return MaterialPageRoute(
                        builder: (context) => const AddBarang());
                  case '/data-kategori':
                    return MaterialPageRoute(
                        builder: (context) => const KategoriPage());
                  case '/data-pembayaran':
                    return MaterialPageRoute(
                        builder: (context) => const PembayaranPage());
                  case '/data-supplier':
                    return MaterialPageRoute(
                        builder: (context) => const SupplierPage());
                  case '/data-barang-masuk':
                    return MaterialPageRoute(
                        builder: (context) => const BarangMasukPage());
                  case '/tamabh-barang-masuk':
                    return MaterialPageRoute(
                        builder: (context) => const AddBarangMasukPage());
                  case '/tambah-supplier':
                    return MaterialPageRoute(
                        builder: (context) => const AddSupplierPage());
                  case '/tambah-kategori':
                    return MaterialPageRoute(
                        builder: (context) => AddKategoriForm());
                  case '/data_transaksi_user':
                    return MaterialPageRoute(
                        builder: (context) => const DataTransaksiUser());
                  default:
                    return null;
                }
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
