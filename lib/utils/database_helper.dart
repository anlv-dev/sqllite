import 'dart:async' as prefix0;

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqllite_ex/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton Database Helper
  static Database _database; //Singleton Database

  String noteTable ='note_table';
  String colID ='id';
  String colTitle ='title';
  String colDescription = 'description';
  String colPriorities = 'priorities';
  String colDate ='date';

  DatabaseHelper._createInstance();

factory DatabaseHelper(){
  if (_databaseHelper == null){
  _databaseHelper = DatabaseHelper._createInstance();
  }
    return _databaseHelper;
}
Future<Database> get database async{
  if (_database == null){
    _database = await initializeDatabase();
  }
  return _database;
}

Future<Database> initializeDatabase() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + 'note.db';

  var noteDb = await openDatabase(path,version: 1,onCreate: _createDb);
  return noteDb;

}

void _createDb(Database db, int newVersion ) async {
  await db.execute('CREATE TABLE noteTable($colID INTEGER PRIMARY KEY AUTO INCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriorities INTEGER, $colDate TEXT)');
}
}
