// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:audio_player/services/track_model.dart';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/indicator.dart';
import 'package:audio_player/viewes/audio/widgets/music_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioView extends StatelessWidget {
  const AudioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) {
        return false;
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            try {
              context.read<AudioBloc>().add(AudioEndEvent());
            } catch (e) {
              throw ('Exception thrown: $e');
            }
            return true;
          },
          child: Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 80.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 20.h,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: 'heri',
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(child: CircleAvatar(radius: 90.r)),
                          const Spacer(),
                          const Indicators(),
                          MusicController()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
