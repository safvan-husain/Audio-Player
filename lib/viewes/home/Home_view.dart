import 'package:audio_player/viewes/home/widgets/music_image.dart';
import 'package:audio_player/viewes/home/widgets/selectable_textbox.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 36, 76),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 106, 70, 212),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 50,
                      child: const Icon(Icons.paragliding_outlined),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 106, 70, 212),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 50,
                      child: const TextField(
                        decoration: InputDecoration(
                            hintText: 'search',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Trending right now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MusicImage(
                      audioPath: 'audios/adam_john.mp3',
                      name: 'Adam Joan',
                    ),
                    const SizedBox(width: 20),
                    MusicImage(
                      audioPath: 'audios/aaro.mp3',
                      name: 'Adam Joan',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SelectableTextOptions()
            ],
          ),
        ),
      ),
    );
  }
}
