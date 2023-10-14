import 'dart:math';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_waveform/just_waveform.dart';

class WaveFormControl extends StatelessWidget {
  const WaveFormControl({
    super.key,
    required this.waveform,
    required this.player,
    required this.isPlaying,
    required this.currentDuration,
    required this.color,
    required this.backgroundColor,
  });

  final Waveform waveform;
  final AudioPlayer player;
  final bool isPlaying;
  final Duration currentDuration;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) =>
          current.changeType == ChangeType.currentDuration ||
          current.changeType == ChangeType.playerState,
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (details) async {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset position = box.globalToLocal(details.globalPosition);
            // position.dx gives you the x-coordinate of the touch event
            // You can then calculate the timestamp based on this x-coordinate
            double ratio = position.dx / box.size.width;
            Duration timestamp = Duration(
                milliseconds:
                    (ratio * waveform.duration.inMilliseconds).round());
            print("Touched at ${timestamp.inSeconds} seconds");
            await player.seek(timestamp);
          },
          onDoubleTap: () {
            if (state.isPlaying) {
              state.controller!.pause();
            } else {
              state.controller!.resume();
            }
          },
          child: SizedBox(
            height: 100.h,
            width: double.infinity,
            child: AudioWaveformWidget(
              waveform: waveform,
              start: Duration.zero,
              duration: waveform.duration,
              currentDuration: state.currentDuration,
              strokeWidth: 2.0,
              pixelsPerStep: 3.0,
              color: color,
              backgroundColor: backgroundColor,
            ),
          ),
        );
      },
    );
  }
}

class AudioWaveformWidget extends StatefulWidget {
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Waveform waveform;
  final Duration start;
  final Duration duration;
  final Duration currentDuration;
  final Color color;
  final Color backgroundColor;

  const AudioWaveformWidget({
    Key? key,
    required this.waveform,
    required this.start,
    required this.duration,
    required this.currentDuration,
    required this.color,
    required this.backgroundColor,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : super(key: key);

  @override
  _AudioWaveformState createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveformWidget> {
  @override
  Widget build(BuildContext context) {
    // d.log('current : ' + widget.currentDuration.toString());
    return ClipRect(
      child: CustomPaint(
        painter: AudioWaveformPainter(
          waveform: widget.waveform,
          start: widget.start,
          duration: widget.duration,
          scale: widget.scale,
          strokeWidth: widget.strokeWidth,
          pixelsPerStep: widget.pixelsPerStep,
          currentDuration: widget.currentDuration,
          color: widget.color,
          backgroundColor: widget.backgroundColor,
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Paint wavePaint;
  final Waveform waveform;
  final Duration start;
  final Duration duration;
  final Duration currentDuration;
  final Color color;
  final Color backgroundColor;

  AudioWaveformPainter({
    required this.waveform,
    required this.start,
    required this.duration,
    required this.currentDuration,
    required this.color,
    required this.backgroundColor,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : wavePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration == Duration.zero) return;

    double width = size.width;
    double height = size.height;

    final waveformPixelsPerWindow = waveform.positionToPixel(duration).toInt();
    final waveformPixelsPerDevicePixel = waveformPixelsPerWindow / width;
    final waveformPixelsPerStep = waveformPixelsPerDevicePixel * pixelsPerStep;
    final sampleOffset = waveform.positionToPixel(start);
    final sampleStart = -sampleOffset % waveformPixelsPerStep;
    for (var i = sampleStart.toDouble();
        i <= waveformPixelsPerWindow + 1.0;
        i += waveformPixelsPerStep) {
      final sampleIdx = (sampleOffset + i).toInt();
      // d.log("currentDuration new painet : " + currentDuration.toString());
      final playedPart = waveform.positionToPixel(currentDuration).toInt();
      if (sampleIdx <= playedPart) {
        wavePaint.color = color; // Change the color of the played part
      } else {
        wavePaint.color =
            backgroundColor; // Change the color of the unplayed part
      }
      final x = i / waveformPixelsPerDevicePixel;
      final minY = normalise(waveform.getPixelMin(sampleIdx), height);
      final maxY = normalise(waveform.getPixelMax(sampleIdx), height);
      canvas.drawLine(
        Offset(x + strokeWidth / 2, max(strokeWidth * 0.75, minY)),
        Offset(x + strokeWidth / 2, min(height - strokeWidth * 0.75, maxY)),
        wavePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return true;
  }

  double normalise(int s, double height) {
    if (waveform.flags == 0) {
      final y = 32768 + (scale * s).clamp(-32768.0, 32767.0).toDouble();
      return height - 1 - y * height / 65536;
    } else {
      final y = 128 + (scale * s).clamp(-128.0, 127.0).toDouble();
      return height - 1 - y * height / 256;
    }
  }
}
