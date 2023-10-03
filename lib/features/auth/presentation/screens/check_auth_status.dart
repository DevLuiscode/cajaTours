import 'package:flutter/material.dart';

class CheckAuthStatus extends StatelessWidget {
  const CheckAuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
