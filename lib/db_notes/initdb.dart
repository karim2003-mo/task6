import 'package:sqflite/sqflite.dart';

class InitDataBase{
  // Singleton pattern to ensure only one instance of the database is created
  static final InitDataBase _instance = InitDataBase._internal();
  factory InitDataBase()=> _instance;
  InitDataBase._internal();
  static Database ? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
   Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path ='$dbPath/notes.db';
    print("table folders and table notes have been created");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
          onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        // 👇 Example of a schema upgrade
        // await db.execute('ALTER TABLE notes ADD COLUMN notename TEXT');
        print("table notes has been updated******************************");
      }}
    );
  }
    Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE folders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      foldername TEXT NOT NULL,
      foldershapepath TEXT NOT NULL
      
      )
      ''');
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        notename TEXT,
        note TEXT,
        date TEXT,
        title TEXT,
        filestylepath TEXT,
        image BLOB,
        folderid INTEGER,
        FOREIGN KEY (folderid) REFERENCES folders(id)
      )
    ''');
  }
  // CRUD operations
  Future<int> insertdata({required String table,required Map<String, dynamic> data}) async {
    final db = await database;
    return await db.insert(table, data);
  }
  Future<List<Map<String, dynamic>>> getAlldata({required String table}) async{
    final db = await database;
    return await db.query(table,
    );
  }
  Future<List<Map<String, dynamic>>> getRecordsByIds({required String table,required List<int> ids}) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    table,
    where: 'folderid IN (${List.filled(ids.length, '?').join(',')})',
    whereArgs: ids,
  );
  return maps;
}
  Future<int> updateNote({required String query,required List updated}) async {
    final db = await database;
    return db.rawUpdate(query,updated);
  }
  Future<int> deletedata({required String query}) async {
    final db = await database;
    try{
    db.execute(query);
    return 1;
    }
    catch(e){
      return 0;
    }
  }
}
