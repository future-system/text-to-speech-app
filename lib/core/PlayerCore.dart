import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:text_to_speech_flutter/core/constants/util_recorded.dart';

class PlayerCore {
  final _player = AudioPlayer();

  void playBytes(Uint8List audio) {
    _player.play(BytesSource(audio));
  }

  void saveAudio(Uint8List audio) {
    saveRecordedFile(audio);
  }

  Future<Uint8List> readAudio(String path) async {
    return await readRecordedFile(path);
  }

  void playScr() async {
    playBytes(await readRecordedFile("${await directoryRecordedPath()}teste.mp3"));
  }

  void pause() {
    _player.pause();
  }

  void stop() {
    _player.stop();
  }

  void resume() {
    _player.resume();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  void setVolume(double volume) {
    _player.setVolume(volume);
  }

  void setPlayerMode(PlayerMode mode) {
    _player.setPlayerMode(mode);
  }

  void setPlaybackRate(double rate) {
    _player.setPlaybackRate(rate);
  }

  void setReleaseMode(ReleaseMode mode) {
    _player.setReleaseMode(mode);
  }

  Future<Duration?> get duration async => _player.getDuration();

  Future<Duration?> get currentPosition async => _player.getCurrentPosition();
}
