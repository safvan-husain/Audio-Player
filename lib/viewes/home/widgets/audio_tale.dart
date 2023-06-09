import 'dart:developer';

import 'package:audio_player/provider/current_audio.dart';
import 'package:audio_player/provider/current_index_provider.dart';
import 'package:audio_player/services/audio_services.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/viewes/audio_view/audio_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/audio_player_provider.dart';

class AudioTale extends StatefulWidget {
  final String audioPath;
  const AudioTale({super.key, required this.audioPath});

  @override
  State<AudioTale> createState() => _AudioTaleState();
}

class _AudioTaleState extends State<AudioTale> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log(extractFileName(widget.audioPath));
        Provider.of<AudioPlayerProvider>(context, listen: false).appenAudio(
          extractFileName(widget.audioPath),
          widget.audioPath,
        );
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
            const Icon(
              Icons.favorite_outline,
            )
          ],
        ),
      ),
    );
  }
}
