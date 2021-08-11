import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yellow_assignment/database/database_helper.dart';
import 'package:yellow_assignment/model/movies.dart';
import 'package:yellow_assignment/views/edit_page.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Movie> movieList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (movieList == null) {
      movieList = List<Movie>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Movie('', '', ''), 'Add Movie');
        },
        tooltip: 'Add Movie',
        child: Icon(Icons.add),
      ),
    );
  }

  StaggeredGridView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return StaggeredGridView.countBuilder(
      // gridDelegate:
      //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: count,
      crossAxisSpacing: 2,
      mainAxisSpacing: 12,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Card(
            color: Colors.white,
            elevation: 3.0,
            child: Column(
              children: [
                Container(
                  child: Image(
                    width: 230,
                    height: 200,
                    image: NetworkImage(this.movieList[position].image),
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      this.movieList[position].title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(top: 5, left: 5),
                        child: Text(this.movieList[position].director))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        debugPrint("ListTile Tapped");
                        navigateToDetail(
                            this.movieList[position], 'Edit movie');
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        _delete(context, movieList[position]);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      crossAxisCount: 2,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(1, index.isEven ? 1.60 : 1.60);
      },
    );
  }

  void _delete(BuildContext context, Movie note) async {
    int result = await databaseHelper.deleteMovie(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Movie Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Movie movie, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieDetail(movie, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Movie>> movieListFuture = databaseHelper.getMovieList();
      movieListFuture.then((movieList) {
        setState(() {
          this.movieList = movieList;
          this.count = movieList.length;
        });
      });
    });
  }
}
