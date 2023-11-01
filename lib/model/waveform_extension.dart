import 'dart:convert';

import 'package:just_waveform/just_waveform.dart';

class WaveformWrapper {
  final Waveform waveform;

  WaveformWrapper(this.waveform);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': waveform.version,
      'flags': waveform.flags,
      'sampleRate': waveform.sampleRate,
      'samplesPerPixel': waveform.samplesPerPixel,
      'length': waveform.length,
      'data': waveform.data,
    };
  }

  static WaveformWrapper fromMap(Map<String, dynamic> map) {
    return WaveformWrapper(
      Waveform(
        version: map['version'] as int,
        flags: map['flags'] as int,
        sampleRate: map['sampleRate'] as int,
        samplesPerPixel: map['samplesPerPixel'] as int,
        length: map['length'] as int,
        data: List<int>.from(
          (map['data'] as List<dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  static WaveformWrapper fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
