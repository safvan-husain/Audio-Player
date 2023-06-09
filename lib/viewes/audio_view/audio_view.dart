import 'package:audio_player/common/icon_box.dart';
import 'package:audio_player/services/audio_services.dart';
import 'package:audio_player/viewes/home/widgets/progress_bar.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class AudioView extends StatefulWidget {
  final String image;
  final String audioPath;
  const AudioView({super.key, required this.image, required this.audioPath});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 36, 76),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              builtAppBar(context),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row builtAppBar(context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: IconBox(icon: Icons.arrow_back_ios_new),
          ),
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
