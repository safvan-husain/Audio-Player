import 'package:audio_player/utils/audio_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/audio_player_provider.dart';

class FavouriteAudio extends StatelessWidget {
  final String audioPath;

  const FavouriteAudio({super.key, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioPlayerProvider>(context, listen: false)
            .appenAudio(audioPath);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/pop3.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              extractFileName(audioPath),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
