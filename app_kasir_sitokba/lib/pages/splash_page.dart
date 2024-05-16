import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushNamed(context, '/login_page');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 340,
              width: 340,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/CV1.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
