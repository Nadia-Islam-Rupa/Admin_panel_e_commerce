import 'package:flutter/material.dart';

class ContainerHome extends StatelessWidget {
  final Color? color;
  const ContainerHome({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 180,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
