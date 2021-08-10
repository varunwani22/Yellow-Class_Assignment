import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yellow_assignment/model/movies.dart';

class DatabaseHelper {
  static late DatabaseHelper databaseHelper;
  static late Database database;

  String movieTable = 'movies';
  String colId = 'id';
  String colTitle = 'title';
  String colDirector = 'director';
  String colImage = 'image';

  DatabaseHelper.createInstance();

  factory DatabaseHelper() {
    // ignore: unnecessary_null_comparison
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.createInstance();
    }
    return databaseHelper;
  }

  Future<Database> get getDatabase async {
    if (database == null) {
      database = await initializeDatabase();
    }
    return database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'movies.db';

    var movieDatabase =
        await openDatabase(path, version: 1, onCreate: createDB);
    return movieDatabase;
  }

  void createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $movieTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colDirector TEXT, $colImage TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database db = await this.getDatabase;

    var result = await db.query(movieTable);
    return result;
  }

  // Insert Operation: Insert a movie object to database
  Future<int> insertMovie(Movie movie) async {
    var db = await this.getDatabase;
    var result = await db.insert(movieTable, movie.toMap());
    return result;
  }

  // Update Operation: Update a movie object and save it to database
  Future<int> updateMovie(Movie movie) async {
    var db = await this.getDatabase;
    var result = await db.update(movieTable, movie.toMap(),
        where: '$colId = ?', whereArgs: [movie.id]);
    return result;
  }

  // Delete Operation: Delete a movie object from database
  Future<int> deleteMovie(int id) async {
    var db = await this.getDatabase;
    int result =
        await db.rawDelete('DELETE FROM $movieTable WHERE $colId = $id');
    return result;
  }

  // Get number of movie objects in database
  Future<int?> getCount() async {
    Database db = await this.getDatabase;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $movieTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Movie>> getNoteList() async {
    var movieMapList = await getMovieMapList(); // Get 'Map List' from database
    int count =
        movieMapList.length; // Count the number of map entries in db table

    // ignore: deprecated_member_use
    List<Movie> movieList = <Movie>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      movieList.add(Movie.fromMap(movieMapList[i]));
    }

    return movieList;
  }
}
