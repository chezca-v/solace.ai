import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentRecordingPath;
  
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    return await _audioRecorder.hasPermission();
  }

  Future<void> startRecording() async {
    try {
      if (await hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = '${const Uuid().v4()}.wav';
        _currentRecordingPath = '${dir.path}/$fileName';
        
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: _currentRecordingPath!,
        );
        _isRecording = true;
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> pauseRecording() async {
    try {
      await _audioRecorder.pause();
      _isRecording = false;
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
  }

  Future<void> resumeRecording() async {
    try {
      await _audioRecorder.resume();
      _isRecording = true;
    } catch (e) {
      debugPrint('Error resuming recording: $e');
    }
  }

  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      return path ?? _currentRecordingPath;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      return null;
    }
  }

  Future<void> playAudio(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        debugPrint('File exists, size: ${await file.length()} bytes');
        await _audioPlayer.play(DeviceFileSource(path));
      } else {
        debugPrint('Audio file does not exist at $path');
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> pausePlayback() async {
    await _audioPlayer.pause();
  }

  Future<void> stopPlayback() async {
    await _audioPlayer.stop();
  }

  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  Stream<Amplitude> get onAmplitudeChanged => _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100));

  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
