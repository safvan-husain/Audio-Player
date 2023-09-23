// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audio_player/utils/waveform_extension.dart';

class AudioModel {
  final String audioPath;
  final WaveformWrapper? waveformWrapper;
  AudioModel({
    required this.audioPath,
    required this.waveformWrapper,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'audioPath': audioPath,
      'waveformWrapper':
          waveformWrapper != null ? waveformWrapper!.toJson() : null,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      audioPath: map['audioPath'] as String,
      waveformWrapper: map['waveformWrapper'] == null
          ? null
          : WaveformWrapper.fromJson(map['waveformWrapper'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioModel.fromJson(String source) =>
      AudioModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
