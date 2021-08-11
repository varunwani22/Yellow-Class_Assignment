import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yellow_assignment/model/movies.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String movieTable = 'movies';
  String colId = 'id';
  String colTitle = 'title';
  String colDirector = 'director';
  String colImage = 'image';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
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
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'movies.db';

    // Open/create the database at a given path
    var moviesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return moviesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $movieTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDirector TEXT, $colImage TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(movieTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertMovie(Movie note) async {
    Database db = await this.database;
    var result = await db.insert(movieTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateMovie(Movie movie) async {
    var db = await this.database;
    var result = await db.update(movieTable, movie.toMap(),
        where: '$colId = ?', whereArgs: [movie.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteMovie(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $movieTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $movieTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Movie>> getMovieList() async {
    var movieMapList = await getMovieMapList(); // Get 'Map List' from database
    int count =
        movieMapList.length; // Count the number of map entries in db table

    List<Movie> movieList = List<Movie>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      movieList.add(Movie.fromMapObject(movieMapList[i]));
    }

    return movieList;
  }
}
