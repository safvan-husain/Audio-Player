import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 36, 76),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 109, 92, 161),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromARGB(137, 210, 205, 205),
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 109, 92, 161),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.favorite_outline,
                        color: Color.fromARGB(137, 210, 205, 205),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent favourites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            )
          ],
        ),
      )),
    );
  }
}
