import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static Database? _db;
  final _dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.14:8080'));

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    if (kIsWeb) return throw UnsupportedError('SQLite not supported on Web');
    
    String path = join(await getDatabasesPath(), 'islami_v1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE prayer_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            prayer_name TEXT,
            is_prayed INTEGER,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> syncWithPC() async {
    try {
      if (kIsWeb) return;
      final db = await database;
      final List<Map<String, dynamic>> records = await db.query('prayer_records');
      
      final syncData = records.map((r) => {
        'date': r['date'],
        'prayer_name': r['prayer_name'],
        'is_prayed': r['is_prayed'] == 1,
      }).toList();

      await _dio.post('/sync', data: syncData);
      print('Sync with PC Successful');
    } catch (e) {
      print('Sync Error: $e');
    }
  }

  Future<void> togglePrayer(String date, String prayerName, bool isPrayed) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> data = _getWebData(prefs);
      data['${date}_$prayerName'] = isPrayed;
      await prefs.setString('web_prayer_records', jsonEncode(data));
      return;
    }

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_records',
      where: 'date = ? AND prayer_name = ?',
      whereArgs: [date, prayerName],
    );

    if (maps.isNotEmpty) {
      await db.update(
        'prayer_records',
        {'is_prayed': isPrayed ? 1 : 0, 'timestamp': DateTime.now().millisecondsSinceEpoch},
        where: 'date = ? AND prayer_name = ?',
        whereArgs: [date, prayerName],
      );
    } else {
      await db.insert(
        'prayer_records',
        {
          'date': date,
          'prayer_name': prayerName,
          'is_prayed': isPrayed ? 1 : 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
    
    // Auto-sync after recording a prayer
    syncWithPC();
  }

  Future<Map<String, bool>> getDayPrayers(String date) async {
    Map<String, bool> result = {
      'Fajr': false, 'Dhuhr': false, 'Asr': false, 'Maghrib': false, 'Isha': false,
    };

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> data = _getWebData(prefs);
      for (var key in result.keys) {
        result[key] = data['${date}_$key'] ?? false;
      }
      return result;
    }

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_records',
      where: 'date = ?',
      whereArgs: [date],
    );

    for (var row in maps) {
      result[row['prayer_name']] = row['is_prayed'] == 1;
    }
    return result;
  }

  Map<String, dynamic> _getWebData(SharedPreferences prefs) {
    String? raw = prefs.getString('web_prayer_records');
    if (raw == null) return {};
    return jsonDecode(raw);
  }
}
