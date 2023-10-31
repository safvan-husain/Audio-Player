import 'dart:developer';
import 'dart:io';

import 'package:audio_player/common/track_model.dart';
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

  //for UI and state changes corresponding to the actions from notification.
  void Function()? onNext;
  void Function()? onPrevious;

  AudioPlayerHandler() {
    player.onPlayerStateChanged.map(_transformEvent).pipe(playbackState);
  }

  Future<void> setNewFile(
    Track track, {
    required void Function() onNext,
    required void Function() onPrevious,
  }) async {
    this.onNext = onNext;
    this.onPrevious = onPrevious;

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

  Directory tempDir = await getTemporaryDirectory();

  File file = File('${tempDir.path}/tempFile');

  await file.writeAsBytes(bytes);

  return file.uri;
}
