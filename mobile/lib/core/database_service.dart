import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
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

  Future<void> togglePrayer(String date, String prayerName, bool isPrayed) async {
    final db = await database;
    
    // Check if record exists
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
  }

  Future<Map<String, bool>> getDayPrayers(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_records',
      where: 'date = ?',
      whereArgs: [date],
    );

    Map<String, bool> result = {
      'Fajr': false,
      'Dhuhr': false,
      'Asr': false,
      'Maghrib': false,
      'Isha': false,
    };

    for (var row in maps) {
      result[row['prayer_name']] = row['is_prayed'] == 1;
    }

    return result;
  }
}
