// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audio_player/common/waveform_extension.dart';
import 'package:flutter/services.dart';

class Track {
  final String trackName;
  final String trackDetail;
  final String trackUrl;
  WaveformWrapper? waveformWrapper;
  final Duration trackDuration;
  final Uint8List coverImage;
  bool isFavorite;

  Track({
    required String trackName,
    required this.trackDetail,
    required this.trackUrl,
    required this.coverImage,
    this.waveformWrapper,
    required this.trackDuration,
    this.isFavorite = false,
  }) : trackName = trackName.replaceAll("'", " ").replaceAll("/", "|");

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'trackName': trackName,
      'trackDetail': trackDetail,
      'trackUrl': trackUrl,
      'trackDuration': trackDuration.inMilliseconds,
      'waveformWrapper':
          waveformWrapper != null ? waveformWrapper!.toJson() : null,
      'coverImage': base64Encode(coverImage)
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
        trackDuration: Duration(milliseconds: map['trackDuration'] as int),
        coverImage: base64Decode(map['coverImage'] as String));
  }
  factory Track.fromLocal(Map<String, dynamic> map, Uint8List coverImage) {
    return Track(
      trackName: map['trackName'].trim() as String,
      trackDetail: map['trackDetail'] as String,
      trackUrl: map['trackUrl'] as String,
      waveformWrapper: map['waveformWrapper'] == null
          ? null
          : WaveformWrapper.fromJson(map['waveformWrapper'] as String),
      trackDuration: Duration(milliseconds: map['trackDuration'] as int),
      coverImage: coverImage,
    );
  }

  Future<Uint8List> placeDefaultImage() async {
    final ByteData bytes = await rootBundle.load('assets/images/pop2.jpeg');
    final Uint8List list = bytes.buffer.asUint8List();
    return list;
  }
}
