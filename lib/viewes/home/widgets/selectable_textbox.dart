import 'package:flutter/material.dart';

class SelectableTextOptions extends StatefulWidget {
  const SelectableTextOptions({super.key});

  @override
  _SelectableTextOptionsState createState() => _SelectableTextOptionsState();
}

class _SelectableTextOptionsState extends State<SelectableTextOptions> {
  int selectedIndex = 0;
  List<String> options = [
    'Trending right now',
    'Rock',
    'Hip Hop',
    'Pop',
    'Radio',
    'Hindi',
    'Tamil'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8.0,
        children: List<Widget>.generate(
          options.length,
          (int index) {
            return ChoiceChip(
              label: Text(
                options[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              selected: selectedIndex == index,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              selectedColor: const Color.fromARGB(255, 43, 67, 176),
              backgroundColor: const Color.fromARGB(255, 46, 36, 76),
              onSelected: (bool selected) {
                setState(() {
                  selectedIndex = selected ? index : -1;
                });
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
