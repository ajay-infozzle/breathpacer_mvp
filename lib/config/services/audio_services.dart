import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';

enum AudioChannel { music, voice, chime, fx }

class AudioOrchestrator {
  final _players = {
    AudioChannel.music: AudioPlayer(),
    AudioChannel.voice: AudioPlayer(),
    AudioChannel.chime: AudioPlayer(),
    AudioChannel.fx: AudioPlayer(),
  };

  // ---------- Play Methods ----------
  Future<void> playMusic(String assetPath, {bool loop = true}) async {
    print("play music start");
    final player = _players[AudioChannel.music]!;
    await player.setAudioSource(AudioSource.asset(assetPath), preload: true);
    print("music asset set");
    if (loop) await player.setLoopMode(LoopMode.one);
    print("music loop set");
    await player.play();
  }

  Future<void> stopMusic() async {
    await _players[AudioChannel.music]!.stop();
  }

  Future<void> playVoice(String assetPath) async {
    try {
      final player = _players[AudioChannel.voice]!;
      await player.stop();
      await player.setAudioSource(AudioSource.asset(assetPath));
      await player.play();
    } catch (e) {
      log(">> playvoice >> ${e.toString()}");
    }
  }

  Future<int> playVoiceAndGetDuration(String assetPath) async {
    final player = _players[AudioChannel.voice]!;

    await player.stop();
    final duration = await player.setAudioSource(
      AudioSource.asset(assetPath),
      preload: true,
    );

    player.play();

    return duration?.inSeconds ?? 5;
  }

  Future<void> playChime() async {
    final player = _players[AudioChannel.chime]!;
    await player.setAudioSource(AudioSource.asset(GuideTrack.chime.path));
    await player.play();
  }

  Future<void> playFx(String assetPath) async {
    final player = _players[AudioChannel.fx]!;
    await player.stop();
    // await setVolume(AudioChannel.voice, 0.2);
    await player.setAudioSource(AudioSource.asset(assetPath));
    await player.play();
    // await setVolume(AudioChannel.voice, 1.0);
  }

  // ---------- Global Controls ----------
  Future<void> pauseAll() async {
    for (var p in _players.values) {
      if (p.playing) await p.pause();
    }
  }

  Future<void> resumeAll() async {
    for (var p in _players.values) {
      if (p.playerState.playing == false &&
          p.playerState.processingState == ProcessingState.ready) {
        await p.play();
      }
    }
  }

  Future<void> stopAll() async {
    for (var p in _players.values) {
      await p.stop();
    }
  }

  Future<void> reset() async {
    for (var p in _players.values) {
      await p.stop();
      await p.seek(Duration.zero);
    }
  }

  // ---------- Individual Controls ----------
  Future<void> pause(AudioChannel channel) async {
    final player = _players[channel]!;
    if (player.playing) await player.pause();
  }

  Future<void> resume(AudioChannel channel) async {
    final player = _players[channel]!;
    if (!player.playing &&
        player.playerState.processingState == ProcessingState.ready) {
      await player.play();
    }
  }

  Future<void> stop(AudioChannel channel) async {
    await _players[channel]!.stop();
  }

  Future<void> setVolume(AudioChannel channel, double volume) async {
    await _players[channel]!.setVolume(volume.clamp(0.0, 1.0));
  }

  // ---------- Cleanup ----------
  void dispose() {
    for (var p in _players.values) {
      p.dispose();
    }
  }
  
}
