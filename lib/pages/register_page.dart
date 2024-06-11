import 'package:app_kasir_sitokba/providers/auth_provider.dart';
import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaUserController = TextEditingController();
  final TextEditingController _jkUserController = TextEditingController();
  final TextEditingController _alamatUserController = TextEditingController();
  final TextEditingController _noTelpUserController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          children: [
            title(),
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
            'Buat Akun Baru',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Mari buat akun Mitra Digital SITOKBA',
            style: grayTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget inputSection() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      height: 800,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextField('Nama Lengkap', _namaUserController),
          buildTextField(
            'Jenis Kelamin',
            _jkUserController,
            dropdownItems: ['Laki-laki', 'Perempuan'],
          ),
          buildTextField('Alamat', _alamatUserController),
          buildTextField('No Telepon', _noTelpUserController),
          buildTextField('Username', _usernameController),
          buildTextField('Password', _passwordController, isPassword: true),
          const SizedBox(height: 30),
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
              onPressed: () async {
                try {
                  final success =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .register(
                    namaUser: _namaUserController.text,
                    jkUser: _jkUserController.text,
                    alamatUser: _alamatUserController.text,
                    noTelpUser: _noTelpUserController.text,
                    username: _usernameController.text,
                    password: _passwordController.text,
                  );
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/login_page');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Center(
                child: Text(
                  'Daftar',
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {bool isPassword = false, List<String>? dropdownItems}) {
    if (dropdownItems != null && dropdownItems.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: kblueTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<String>(
            value: dropdownItems.contains(controller.text)
                ? controller.text
                : null,
            items: dropdownItems.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                controller.text = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: kblueTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    }
  }

  Widget daftarSection() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 50),
      child: SizedBox(
        width: double.infinity,
        height: 24,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login_page');
          },
          child: Text(
            'Sudah Punya Akun?',
            style: grayTextStyle.copyWith(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
