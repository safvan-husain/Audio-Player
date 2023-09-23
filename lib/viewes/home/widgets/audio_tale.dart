import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/audio_services.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/viewes/audio/audio_view.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioTale extends StatefulWidget {
  final int index;
  final List<AudioModel> paths;
  // final AudioServices audio;
  const AudioTale({
    Key? key,
    required this.index,
    required this.paths,
  })
  // : audio = AudioServices(audioPath: audioPath),
  : super(key: key);

  @override
  State<AudioTale> createState() => _AudioTaleState();
}

class _AudioTaleState extends State<AudioTale> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => AudioView(
                  index: widget.index,
                  paths: widget.paths,
                )));
      },
      onLongPress: () {
        DataBaseService().deleteMusicPath(widget.paths[widget.index].audioPath);
        context.read<HomeBloc>().add(RenderMusicHomeEvent());
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
                    extractFileName(widget.paths[widget.index].audioPath),
                    style: const TextStyle(
                      fontSize: 15,
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
              onTap: () {},
              child: const Icon(
                Icons.favorite_outline,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
