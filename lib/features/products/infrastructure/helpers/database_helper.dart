import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, "myapp.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            vendor TEXT,
            productName TEXT,
            rating INTEGER,
            imageUrl TEXT
          )
        ''');
      },
    );
  }
}
