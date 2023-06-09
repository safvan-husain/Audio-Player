import 'package:audio_player/provider/faviourate_audio_provider.dart';
import 'package:audio_player/services/audio_services.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/audio_player_provider.dart';

class AudioTale extends StatefulWidget {
  final String audioPath;
  final AudioServices audio;
  AudioTale({Key? key, required this.audioPath})
      : audio = AudioServices(audioPath: audioPath),
        super(key: key);

  @override
  State<AudioTale> createState() => _AudioTaleState();
}

class _AudioTaleState extends State<AudioTale> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //adding to the playing List
        Provider.of<AudioPlayerProvider>(context, listen: false)
            .appenAudio(widget.audioPath);
      },
      child: SizedBox(
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
                children: [
                  Text(
                    extractFileName(widget.audioPath),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Singer',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (context
                    .read<FavouriteAudioProvider>()
                    .isFavourite(widget.audioPath)) {
                  Provider.of<FavouriteAudioProvider>(context, listen: false)
                      .removeFromFavourite(widget.audioPath);
                } else {
                  Provider.of<FavouriteAudioProvider>(context, listen: false)
                      .addTOFavourite(widget.audioPath);
                }
              },
              child: Icon(
                context
                        .watch<FavouriteAudioProvider>()
                        .isFavourite(widget.audioPath)
                    ? Icons.favorite_outlined
                    : Icons.favorite_outline,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
