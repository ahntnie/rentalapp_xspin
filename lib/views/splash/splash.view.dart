import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/views/index/index.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const IndexPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColor.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0), // Bán kính bo góc
                child: Image.asset(
                  'assets/XSPIN-CTTB.png', scale: 1,
                  width: MediaQuery.of(context).size.width *
                      0.8, // Chiếm 60% chiều rộng màn hình
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Lottie.asset('assets/loading.json',
                    width: 300, height: 300)),
          ],
        ),
      ),
    );
  }
}
