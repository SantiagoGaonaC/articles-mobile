import 'package:flutter/material.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_checkout_rounded, size: 100, color: Colors.white),
            SizedBox(height: 16),
            CircularProgressIndicator(strokeWidth: 5),
          ],
        ),
      ),
    );
  }
}
