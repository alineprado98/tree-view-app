import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SqfliteConfig {
  late Database db;
  static const int DATABASE_VERSION = int.fromEnvironment("DATABASE_VERSION");
  static const String DATABASE_PASSWORD = String.fromEnvironment("DATABASE_KEY", defaultValue: "");

  static final SqfliteConfig _instance = SqfliteConfig._();
  SqfliteConfig._();

  static Future<SqfliteConfig> getInstance() async {
    await _instance.startDatabase();
    return _instance;
  }

  Future<void> startDatabase() async {
    try {
      final path = await getDatabasesPath();

      final dbPath = join(path, 'database.db');
      print('PATH => $dbPath');
      db = await openDatabase(
        version: 1,
        dbPath,
        password: '123',
        singleInstance: true,
        readOnly: false,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: onDatabaseDowngradeDelete,
      );
      await showTables();
    } catch (e) {
      debugPrint('🟥  SqfliteConfig -> ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    int firstRun = 1;
    await _executeMigrations(db, firstRun);
    int currentVersion = version;
    while (firstRun < currentVersion) {
      firstRun++;
      await _executeMigrations(db, firstRun);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    int executeVersion = oldVersion;
    while (executeVersion < newVersion) {
      executeVersion++;
      await _executeMigrations(db, executeVersion);
    }
  }

  Future<void> _executeMigrations(Database db, int version) async {
    try {
      final migrationFilePath = 'assets/migrations/V$version.sql';

      // search for the sql to be executed
      String sql = await rootBundle.loadString(migrationFilePath).then((data) => data).onError((error, stackTrace) {
        debugPrint(' 🟥 SqfliteConfig => ${error.toString()}');
        return '';
      });

      if (sql.isNotEmpty) {
        List<String> sqlCommands = await sqlFormat(sqlValue: sql);

        for (var sql in sqlCommands) {
          await db.execute(sql);
        }
        debugPrint('🟩 sql completed => $migrationFilePath');
      }
    } catch (e) {
      debugPrint('🟥 SqfliteConfig => ${e.toString()}');
      rethrow;
    }
  }

  Future<List<String>> sqlFormat({required String sqlValue}) async {
    try {
      return sqlValue.split(';').map((command) => command.trim()).where((command) => command.isNotEmpty).toList();
    } catch (e) {
      debugPrint('🟥  SqfliteConfig -> ${e.toString()}');
      return <String>[];
    }
  }

  Future<void> _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<void> showTables() async {
    final List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

    for (var table in tables) {
      String tableName = table['name'];
      final List<Map<String, dynamic>> columns = await db.rawQuery('''PRAGMA table_info($tableName);''');
      debugPrint('==> columns of table |$tableName|: ${columns.toList().toString()}');
    }
  }
}
