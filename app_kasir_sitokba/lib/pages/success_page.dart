import 'package:app_kasir_sitokba/theme/theme.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String noTransaksi;
  const SuccessPage({super.key, required this.noTransaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 278,
              width: 278,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/success.png',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Text(
              'Order Items Success',
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Nomor Transaksi Anda : \n $noTransaksi',
              textAlign: TextAlign.center,
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'silahkan bayar di kasir dan \n berikan nomor transaksi kamu',
              textAlign: TextAlign.center,
              style: whiteTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(56),
                    )),
                onPressed: () {
                  Navigator.pushNamed(context, '/home_page');
                },
                child: Center(
                  child: Text(
                    'Back To Home',
                    style: blueTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        )),
      ),
    );
  }
}
