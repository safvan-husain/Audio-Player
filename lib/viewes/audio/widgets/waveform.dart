import 'dart:math';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_waveform/just_waveform.dart';

class WaveFormVisulizer extends StatelessWidget {
  const WaveFormVisulizer({
    super.key,
    required this.waveform,
    required this.currentDuration,
  });

  final Waveform waveform;

  final Duration currentDuration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) =>
          current.changeType == ChangeType.currentDuration ||
          current.changeType == ChangeType.playerState,
      builder: (context, state) {
        return SizedBox(
          height: 100.h,
          width: double.infinity,
          child: AudioWaveformWidget(
            waveform: waveform,
            start: Duration.zero,
            duration: waveform.duration,
            currentDuration: state.currentDuration,
            strokeWidth: 2.0,
            pixelsPerStep: 3.0,
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

  const AudioWaveformWidget({
    Key? key,
    required this.waveform,
    required this.start,
    required this.duration,
    required this.currentDuration,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : super(key: key);

  @override
  AudioWaveformState createState() => AudioWaveformState();
}

class AudioWaveformState extends State<AudioWaveformWidget> {
  @override
  Widget build(BuildContext context) {
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
          color: Theme.of(context).focusColor,
          backgroundColor: Theme.of(context).cardColor,
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
