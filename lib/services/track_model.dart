// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audio_player/utils/waveform_extension.dart';

class Track {
  final String trackName;
  final String trackDetail;
  final String trackUrl;
  final WaveformWrapper? waveformWrapper;

  Track({
    required String trackName,
    required this.trackDetail,
    required this.trackUrl,
    this.waveformWrapper,
  }) : trackName = trackName.replaceAll("'", " ").replaceAll("/", "|");

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'trackName': trackName,
      'trackDetail': trackDetail,
      'trackUrl': trackUrl,
      'waveformWrapper':
          waveformWrapper != null ? waveformWrapper!.toJson() : null,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      trackName: map['trackName'] as String,
      trackDetail: map['trackDetail'] as String,
      trackUrl: map['trackUrl'] as String,
      waveformWrapper: map['waveformWrapper'] == null
          ? null
          : WaveformWrapper.fromJson(map['waveformWrapper'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);
}
