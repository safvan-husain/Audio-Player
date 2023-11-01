// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_player/viewes/audio/audio_view.dart';
import 'package:audio_player/bloc/audio bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:audio_player/model/track_model.dart';
import 'package:audio_player/bloc/home bloc/home_bloc.dart';

class AudioSearchTale extends StatelessWidget {
  final Track track;
  const AudioSearchTale({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeState state = context.read<HomeBloc>().state;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const AudioView()),
        );
        context.read<AudioBloc>().add(
              AudioInitEvent(
                state.trackList,
                state.trackList.indexWhere(
                    (element) => element.trackName == track.trackName),
                MediaQuery.of(context).size.width,
              ),
            );
      },
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              height: 80.r,
              child: Image.memory(
                track.coverImage,
                fit: BoxFit.fitHeight,
                gaplessPlayback: true,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cutString(track.trackName),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    track.trackDetail,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String cutString(String input) {
  RegExp regExp = RegExp(r'^[a-zA-Z0-9 ,]*');
  Match? match = regExp.firstMatch(input);
  String output = match?.group(0) ?? '';
  return output.length < 10 ? input : output;
}
