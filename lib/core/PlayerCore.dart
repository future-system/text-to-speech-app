import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class PlayerCore {
  final _player = AudioPlayer();

  void playBytes(Uint8List audio) {
    _player.play(BytesSource(audio));
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
