// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/indicator.dart';
import 'package:audio_player/viewes/audio/widgets/music_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioView extends StatefulWidget {
  final String audioPath;
  const AudioView({
    Key? key,
    required this.audioPath,
  }) : super(key: key);

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioBloc>().add(
            AudioInitEvent(widget.audioPath, MediaQuery.of(context).size.width),
          );
    });
  }

  // Future<void> prepare() async {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioBloc, AudioState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: WillPopScope(
        onWillPop: () async {
          log('before pop');
          log('AudioBloc state: ${context.read<AudioBloc>().state}');
          try {
            context.read<AudioBloc>().add(AudioEndEvent());
          } catch (e) {
            throw ('Exception thrown: $e');
          }
          log('after pop');
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.amber,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: 100.h,
                left: 20.w,
                right: 20.w,
                bottom: 20.h,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 90.r,
                    ),
                   const Spacer(),
                    const Indicators(),
                    const MusicController()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
