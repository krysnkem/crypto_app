import 'package:crypto_app/core/routing/fade_navigator_extenstion.dart';
import 'package:crypto_app/core/routing/routing.dart';
import 'package:crypto_app/core/util/pngs.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.pushReplacementFade(RoutePath.assetList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Pngs.archonit, width: 200, fit: BoxFit.contain),
            const SizedBox(height: 8),
            const Text(
              'Crypto App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
