import 'dart:convert';

/// A private local journal entry with AI metadata and tags
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String type; // e.g. 'Decision', 'Gratitude', 'Reflection', 'Voice'
  final List<String> tags;
  final String? solBadge;
  final String? solWhisper;
  final int wordCount;
  final String? audioDuration;
  final String? audioFilePath;
  final bool isAudioDraft;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.type = 'Reflection',
    this.tags = const [],
    this.solBadge,
    this.solWhisper,
    this.wordCount = 0,
    this.audioDuration,
    this.audioFilePath,
    this.isAudioDraft = false,
  });

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[createdAt.month - 1];
    final hour = createdAt.hour > 12 ? createdAt.hour - 12 : (createdAt.hour == 0 ? 12 : createdAt.hour);
    final period = createdAt.hour >= 12 ? 'PM' : 'AM';
    final min = createdAt.minute.toString().padLeft(2, '0');
    return '$month ${createdAt.day}, ${createdAt.year} • $hour:$min $period';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'type': type,
      'tags': jsonEncode(tags),
      'sol_badge': solBadge,
      'sol_whisper': solWhisper,
      'word_count': wordCount,
      'audio_duration': audioDuration,
      'audio_file_path': audioFilePath,
      'is_audio_draft': isAudioDraft ? 1 : 0,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    List<String> parsedTags = [];
    if (map['tags'] != null) {
      try {
        parsedTags = List<String>.from(jsonDecode(map['tags'] as String));
      } catch (_) {
        parsedTags = [];
      }
    }

    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      type: (map['type'] as String?) ?? 'Reflection',
      tags: parsedTags,
      solBadge: map['sol_badge'] as String?,
      solWhisper: map['sol_whisper'] as String?,
      wordCount: (map['word_count'] as int?) ?? 0,
      audioDuration: map['audio_duration'] as String?,
      audioFilePath: map['audio_file_path'] as String?,
      isAudioDraft: (map['is_audio_draft'] as int?) == 1,
    );
  }
}
