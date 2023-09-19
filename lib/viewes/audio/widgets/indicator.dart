import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Indicators extends StatelessWidget {
  const Indicators({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return SizedBox(
          height: 100.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
