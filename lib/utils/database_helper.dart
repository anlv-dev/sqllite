import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqllite_ex/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton Database Helper
  static Database _database; //Singleton Database

  String noteTable = 'note_table';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriorities = 'priorities';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    var noteDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return noteDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE noteTable($colID INTEGER PRIMARY KEY AUTO INCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriorities INTEGER, $colDate TEXT)');
  }

//Fetch data from DB
  Future<List<Map<String, dynamic>>> getNoteMapToList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: 'colPriorities ASC');
    return result;
  }

//insert
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

//Update
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colID = ?', whereArgs: [note.id]);
    return result;
  }

//Delete

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colID= $id');
    return result;
  }

  //Get number object in database

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Convert List Map to List Note

  Future<List<Note>> getNoteToList() async {
    var noteMapList = await getNoteMapToList();
    int count = noteMapList.length; //Count elements of Map List

    List<Note> noteList = List<Note>();

    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
