import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future loadin() async {
    return await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  void initState() {
    loadin();
    super.initState();
  }

  @override
  void dispose() {
    loadin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(),
    );
  }
}
