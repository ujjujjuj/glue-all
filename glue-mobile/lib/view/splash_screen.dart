import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Glue',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.15,
                  color: Color(0xff2C2B2B),
                  fontFamily: "Proxima Nova"),
            ),
          ],
        ),
      ),
    );
  }
}
