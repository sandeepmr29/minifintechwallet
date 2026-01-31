import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const CircularLoader({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}