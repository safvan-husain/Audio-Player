import 'dart:developer';
import 'dart:io';

import 'package:audio_player/services/track_model.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  static MediaItem _item = const MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
  );
  final player = AudioPlayer();

  //for UI and state changes corresponding to the actions.
  void Function()? onNext;
  void Function()? onPrevious;
  late Future<void> Function() onStop;

  AudioPlayerHandler() {
    player.onPlayerStateChanged.map(_transformEvent).pipe(playbackState);
    player.onDurationChanged.listen((d) {
      print(d);
    });
  }

  Future<void> setNewFile(
    Track track, {
    required void Function() onNext,
    required void Function() onPrevious,
    required Future<void> Function() onStop,
  }) async {
    log('setNewFile');
    this.onNext = onNext;
    this.onPrevious = onPrevious;
    this.onStop = onStop;

    _item = MediaItem(
      id: track.trackUrl,
      title: track.trackName,
      artist: track.trackDetail,
      duration: track.trackDuration,
      artUri: await _assetToFileUri(),
    );
    mediaItem.add(_item);
    try {
      await player.play(DeviceFileSource(track.trackUrl));
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> skipToNext() async {
    log('skip to nect');
    if (onNext != null) onNext!();
  }

  @override
  Future<void> skipToPrevious() async {
    if (onPrevious != null) onPrevious!();
  }

  @override
  Future<void> stop() async {
    await player.stop();
  }

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> play() => player.resume();

  @override
  Future<void> pause() => player.pause();

  PlaybackState _transformEvent(PlayerState event) {
    bool isPlaying = event == PlayerState.playing;
    log(event.toString());
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        isPlaying ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
            PlayerState.paused: AudioProcessingState.ready,
            PlayerState.playing: AudioProcessingState.ready,
          }[event] ??
          AudioProcessingState.idle,
      playing: isPlaying,
      // updatePosition: _player.position,
      // bufferedPosition: _player.bufferedPosition,
      // speed: _player.speed,
      // queueIndex: event.currentIndex,
    );
  }
}

Future<Uri> _assetToFileUri() async {
  // Read asset as bytes
  ByteData byteData = await rootBundle.load('assets/images/track.webp');
  Uint8List bytes = byteData.buffer.asUint8List();

  // Get temporary directory
  Directory tempDir = await getTemporaryDirectory();

  // Create new file in temporary directory
  File file = File('${tempDir.path}/tempFile');

  // Write bytes to the file
  await file.writeAsBytes(bytes);

  // Return the file's URI
  return file.uri;
}
