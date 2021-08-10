import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yellow_assignment/database/database_helper.dart';
import 'package:yellow_assignment/model/movies.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<Movie> movieList;

  ListView getMovieListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Image(
                image: NetworkImage('dsdasd'),
              ),
            ),
            title: Text(this.movieList[position].title),
            subtitle: Text(this.movieList[position].director),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.amber,
              ),
              onTap: () {
                deteteMovie(context, movieList[position]);
                navigateToDetail(this.movieList[position], 'Edit Movie');
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> deteteMovie(BuildContext context, Movie movieList) async {
    int result = await databaseHelper.deleteMovie(movieList.id);
    if (result != 0) {
      snackBar(context, 'Movie Deleted Successfully');
      updateListViews();
    }
  }

  void snackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (movieList == null) {
      movieList = <Movie>[];
      updateListViews();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: getMovieListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Movie('', '', ''), 'Add Movie');
        },
        tooltip: 'Add Movie',
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToDetail(Movie movie, String s) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieEditPage(
        movie,
      );
    }));
  }

  void updateListViews() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Movie>> movieListFuture = databaseHelper.getMoviesList();
      movieListFuture.then((movieList) {
        setState(() {
          this.movieList = movieList;
          this.count = movieList.length;
        });
      });
    });
  }
}
