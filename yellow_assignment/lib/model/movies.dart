class Movie {
  int id = 0;
  String movieTitle = '';
  String directorName = '';
  String posterImage = '';

  Movie(this.movieTitle, this.directorName, this.posterImage);

  Movie.withId(this.id, this.movieTitle, this.directorName, this.posterImage);

  int get ids => id;
  String get title => movieTitle;
  String get director => directorName;
  String get image => posterImage;

  set title(String newTitle) {
    this.movieTitle = newTitle;
  }

  set director(String newDirector) {
    this.directorName = newDirector;
  }

  set image(String newImage) {
    this.posterImage = newImage;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    // ignore: unnecessary_null_comparison
    if (ids != null) {
      map['ids'] = id;
    }
    map['title'] = movieTitle;
    map['director'] = directorName;
    map['image'] = posterImage;

    return map;
  }

  Movie.fromMap(Map<String, dynamic> map) {
    this.id = map['ids'];
    this.movieTitle = map['title'];
    this.directorName = map['director'];
    this.posterImage = map['image'];
  }
}
