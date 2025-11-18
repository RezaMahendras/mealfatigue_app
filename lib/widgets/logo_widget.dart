import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final bool big;
  const LogoWidget({this.big = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = big ? 140.0 : 96.0;
    return Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: const Text('Logo'),
        );
      },
    );
  }
}
