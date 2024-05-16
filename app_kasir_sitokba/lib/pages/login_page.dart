import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:app_kasir_sitokba/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  // ignore: use_super_parameters
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("token");
    String? savedUsername = pref.getString("savedUsername");
    String? savedPassword = pref.getString("savedPassword");

    if (val != null) {
      _usernameController.text = savedUsername ?? '';
      _passwordController.text = savedPassword ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          children: [
            title(),
            logoApp(),
            inputSection(),
            daftarSection(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login Account',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          Text(
            'Selamat Datang Mitra CV.YOHANA',
            style: grayTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget logoApp() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          height: 230,
          width: 230,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/CV1.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget inputSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      height: 316,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username',
                style: kblueTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Password',
                style: kblueTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(56),
                      )),
                  onPressed: () async {
                    bool success = await authProvider.login(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    );
                    if (success) {
                      authProvider.saveCredentials(
                        _usernameController.text,
                        _passwordController.text,
                      );

                      Navigator.pushNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        '/home_page',
                        arguments: {
                          'id': authProvider.user!.id,
                          'namaUser': authProvider.user!.namaUser,
                          'username': authProvider.user!.username,
                        },
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login failed'),
                        ),
                      );
                    }
                  },
                  child: Center(
                    child: Text(
                      'Masuk',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget daftarSection() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: SizedBox(
        width: double.infinity,
        height: 24,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Buat Akun Baru',
            style: grayTextStyle.copyWith(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
