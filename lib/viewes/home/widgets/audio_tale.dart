import 'package:flutter/material.dart';

class AudioTale extends StatefulWidget {
  const AudioTale({super.key});

  @override
  State<AudioTale> createState() => _AudioTaleState();
}

class _AudioTaleState extends State<AudioTale> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                'assets/images/pop2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Music name',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Singer',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          const Icon(
            Icons.favorite_outline,
          )
        ],
      ),
    );
  }
}
