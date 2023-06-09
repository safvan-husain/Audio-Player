import 'package:audio_player/common/icon_box.dart';
import 'package:audio_player/provider/current_audio.dart';
import 'package:audio_player/viewes/home/widgets/audio_list.dart';
import 'package:audio_player/viewes/home/widgets/music_image.dart';
import 'package:audio_player/viewes/home/widgets/progress_bar.dart';
import 'package:audio_player/viewes/home/widgets/selectable_textbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 36, 76),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  builtSearchBar(),
                  const SizedBox(height: 10),
                  const Text(
                    'Trending right now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // builtCarouselMusic(),
                  const SizedBox(
                    height: 10,
                  ),
                  const SelectableTextOptions(),
                  const SizedBox(
                    height: 10,
                  ),
                  const AudioList()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView builtCarouselMusic() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MusicImage(
            audioPath: 'audios/adam_john.mp3',
            name: 'Adam Joan',
            image: 'assets/images/pop.jpeg',
          ),
          const SizedBox(width: 20),
          MusicImage(
            audioPath: 'audios/aaro.mp3',
            name: 'Aaro',
            image: 'assets/images/pop3.jpeg',
          ),
          const SizedBox(width: 20),
          MusicImage(
            audioPath: 'audios/bgm.mp3',
            name: 'BGM',
            image: 'assets/images/pop2.jpeg',
          ),
        ],
      ),
    );
  }

  Row builtSearchBar() {
    return Row(
      children: [
        const Expanded(
          child: IconBox(icon: Icons.receipt),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 109, 92, 161),
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
    );
  }
}
