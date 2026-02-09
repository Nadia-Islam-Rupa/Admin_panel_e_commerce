import 'package:flutter/material.dart';

class ContainerHome extends StatelessWidget {
  final Color? color;
  const ContainerHome({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 100,
      width: 180,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Total Users"), Text("100")],
          ),
        ],
      ),
    );
  }
}
