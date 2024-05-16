// ignore_for_file: use_build_context_synchronously

import 'package:app_kasir_sitokba/pages/login_page.dart';
// import 'package:app_kasir_sitokba/providers/auth_provider.dart';
import 'package:app_kasir_sitokba/service/auth_service.dart';
import 'package:app_kasir_sitokba/service/logout_service.dart';
import 'package:flutter/material.dart';
import 'package:app_kasir_sitokba/model/kategori_mode.dart';
import 'package:app_kasir_sitokba/service/kategori_api_service.dart';
import 'package:app_kasir_sitokba/model/barang_model.dart';
import 'package:app_kasir_sitokba/service/baran_api_service.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:app_kasir_sitokba/pages/cart_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = "";
  String typeUser = "";

  late Future<List<Barang>> futureBarang;
  late Future<List<Jenis>> futureJenis;
  late int userId;

  Map<String, Barang> cartItems = {};

  String selectedJenis = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureBarang = ApiService.fetchBarang();
    futureJenis = ApiKategoriService.fetchJenis();
    getCred();

    futureJenis.then((jenis) {
      if (jenis.isNotEmpty) {
        setState(() {
          selectedJenis = '';
        });
      }
    });
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      typeUser = pref.getString("typeuser")!;
    });
  }

  List<Barang> filteredBarangs(List<Barang> barangs) {
    if (searchController.text.isEmpty) {
      if (selectedJenis.isEmpty) {
        return barangs;
      }
      return barangs.where((barang) {
        return barang.jenisBarang.namaJenis.toLowerCase() ==
            selectedJenis.toLowerCase();
      }).toList();
    }

    return barangs.where((barang) {
      return barang.namaBarang
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) &&
          (selectedJenis.isEmpty ||
              barang.jenisBarang.namaJenis.toLowerCase() ==
                  selectedJenis.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    // String greetingText =
    //     typeUser == "1" ? "Hallo Pelanggan" : "Hallo Pengguna";

    int itemCount =
        cartItems.values.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        backgroundColor: kWhiteColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: kPrimaryColor,
              child: const Center(
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home_page');
              },
              child: const ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
            ),
            if (typeUser == "2")
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/data-barang');
                },
                child: ListTile(
                  leading: const Icon(Icons.local_shipping),
                  title: Text(
                    'Data Barang',
                    style: blackTextStyle.copyWith(),
                  ),
                ),
              ),
            if (typeUser == "2")
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/data-kategori');
                },
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(
                    'Data Kategori',
                    style: blackTextStyle.copyWith(),
                  ),
                ),
              ),
            if (typeUser == "2")
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/data-pembayaran');
                },
                child: ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text(
                    'Data Pembayaran',
                    style: blackTextStyle.copyWith(),
                  ),
                ),
              ),
            if (typeUser == "2")
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/data-supplier');
                },
                child: ListTile(
                  leading: const Icon(Icons.fire_truck),
                  title: Text(
                    'Data Supplier',
                    style: blackTextStyle.copyWith(),
                  ),
                ),
              ),
            if (typeUser == "2")
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/data-barang-masuk');
                },
                child: ListTile(
                  leading: const Icon(Icons.inbox),
                  title: Text(
                    'Data Barang Masuk',
                    style: blackTextStyle.copyWith(),
                  ),
                ),
              ),
            GestureDetector(
              onTap: () async {
                final authService =
                    Provider.of<AuthService>(context, listen: false);

                try {
                  bool loggedOut =
                      await LogoutApiService.logout(AuthService.token!);
                  if (loggedOut) {
                    // Clear token in AuthService after successful logout
                    authService.updateToken(null);

                    // Clear token in SharedPreferences
                    await LogoutApiService.clearToken();

                    // Navigate back to login page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $error')),
                  );
                }
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("${AuthService.token}"),
              // Text(greetingText),
              // Text('Hallo ${authProvider.user?.id}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {}); // Refresh UI saat teks berubah
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: kWhiteColor,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Kategori',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedJenis = '';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: selectedJenis.isEmpty
                              ? kGreenColor
                              : kTranparantColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedJenis.isEmpty
                                ? kGreenColor
                                : kblueborderColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'All',
                            style: selectedJenis.isEmpty
                                ? whiteTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )
                                : blueborderTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<List<Jenis>>(
                      future: futureJenis,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Jenis> jenis = snapshot.data!;
                          return Row(
                            children: jenis.map((item) {
                              bool isSelected = item.namaJenis == selectedJenis;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedJenis = item.namaJenis;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? kGreenColor
                                        : kTranparantColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? kGreenColor
                                          : kblueborderColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.namaJenis,
                                      style: isSelected
                                          ? whiteTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                            )
                                          : blueborderTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Barang>>(
                future: futureBarang,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Barang> barangs = snapshot.data!;
                    List<Barang> filteredList = filteredBarangs(barangs);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        (filteredList.length / 2).ceil(),
                        (index) {
                          int startIndex = index * 2;
                          int endIndex = (index + 1) * 2;
                          endIndex = endIndex > filteredList.length
                              ? filteredList.length
                              : endIndex;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                for (var i = startIndex; i < endIndex; i++)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (cartItems.containsKey(
                                            filteredList[i].namaBarang)) {
                                          cartItems[filteredList[i].namaBarang]!
                                              .quantity += 1;
                                        } else {
                                          cartItems[
                                                  filteredList[i].namaBarang] =
                                              filteredList[i]
                                                  .copyWith(quantity: 1);
                                        }
                                        itemCount = cartItems.values.fold(
                                            0,
                                            (sum, item) =>
                                                sum +
                                                item.quantity); // Update itemCount
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Added ${filteredList[i].namaBarang} to cart\nPrice: ${filteredList[i].hargaJual}',
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 140,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    3 * defaultMargin) /
                                                2,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kWhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  filteredList[i].namaBarang,
                                                  style:
                                                      blackTextStyle.copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Rp ${filteredList[i].hargaJual}',
                                                  style: blueborderTextStyle
                                                      .copyWith(),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  filteredList[i]
                                                      .jenisBarang
                                                      .namaJenis,
                                                  style: TextStyle(
                                                    color: kGreyColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  height: 25,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Add',
                                                      style: whiteTextStyle,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: kWhiteColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: cartItems.values.toList(),
                    onUpdateCart: (updatedCartItems) {
                      setState(() {
                        cartItems = {
                          for (var item in updatedCartItems)
                            item.namaBarang: item
                        };
                      });
                    },
                  ),
                ),
              );
            },
            child: Icon(
              Icons.shopping_cart,
              color: kPrimaryColor,
            ),
          ),
          if (itemCount > 0)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: kRedColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 20,
                height: 20,
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        '',
                        colors: [
                          kTranparantColor,
                          kTranparantColor,
                          kTranparantColor,
                        ],
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
