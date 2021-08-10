import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yellow_assignment/database/database_helper.dart';
import 'package:yellow_assignment/model/movies.dart';

class MovieEditPage extends StatefulWidget {
  final String appBarTitle;
  final Movie movie;

  MovieEditPage(this.movie, this.appBarTitle);

  @override
  _MovieEditPageState createState() => _MovieEditPageState();
}

class _MovieEditPageState extends State<MovieEditPage> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Movie movie;

  TextEditingController titleController = TextEditingController();
  TextEditingController directorController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  _MovieEditPageState(this.appBarTitle, this.movie);

  @override
  Widget build(BuildContext context) {
    titleController.text = movie.title;
    directorController.text = movie.director;
    imageController.text = movie.image;

    return Container();
  }
}
