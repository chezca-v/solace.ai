import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

/// Centralized database helper to manage SQLite initialization and connections.
/// This keeps business logic (Services) decoupled from database structure code.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _db;

  Future<Database?> get database async {
    if (kIsWeb) return null; // SQLite is not supported on web natively
    if (_db != null) return _db;
    
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'solace_journal.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS entries (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            created_at TEXT,
            type TEXT,
            tags TEXT,
            sol_badge TEXT,
            sol_whisper TEXT,
            word_count INTEGER,
            audio_duration TEXT,
            is_audio_draft INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user_preferences (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS memories (
            id TEXT PRIMARY KEY,
            title TEXT,
            quote_or_description TEXT,
            source TEXT,
            category TEXT,
            subcategory TEXT,
            is_quote INTEGER,
            is_active INTEGER,
            created_at TEXT
          )
        ''');
      },
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS memories (
            id TEXT PRIMARY KEY,
            title TEXT,
            quote_or_description TEXT,
            source TEXT,
            category TEXT,
            subcategory TEXT,
            is_quote INTEGER,
            is_active INTEGER,
            created_at TEXT
          )
        ''');
      },
    );
  }
}
