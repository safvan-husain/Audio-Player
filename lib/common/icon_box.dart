import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  const IconBox({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 109, 92, 161),
        borderRadius: BorderRadius.circular(10),
      ),
      width: 50,
      height: 50,
      child: Icon(
        icon,
        color: const Color.fromARGB(137, 210, 205, 205),
        size: 30,
      ),
    );
  }
}
