import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DownloadDailogue extends StatelessWidget {
  const DownloadDailogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          type: MaterialType.transparency,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: BlocBuilder<PlayListWindowBloc, PlayListWindowState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(15.r),
                width: 200.w,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text('processing'),
              );
            },
          ),
        ),
      ),
    );
  }
}
