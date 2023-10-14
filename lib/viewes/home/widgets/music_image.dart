import 'package:audio_player/services/audio_services.dart';
import 'package:flutter/material.dart';

class MusicImage extends StatefulWidget {
  final String audioPath;
  final String name;
  final String image;
  final AudioServices player;

  MusicImage({
    Key? key,
    required this.audioPath,
    required this.name,
    required this.image,
  })  : player = AudioServices(audioPath: audioPath),
        super(key: key);

  @override
  State<MusicImage> createState() => _MusicImageState();
}

class _MusicImageState extends State<MusicImage> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Positioned(
          right: 10,
          child: Icon(Icons.more_horiz_outlined),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 43, 67, 176),
            ),
            height: 80,
            width: 100,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Icon(
                            Icons.music_note_rounded,
                            color: Colors.white,
                          ),
                          Flexible(
                            child: Text(
                              "muse - simulation theory",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (isPlaying) {
                        widget.player.pause();
                      } else {
                        widget.player.play();
                      }

                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
