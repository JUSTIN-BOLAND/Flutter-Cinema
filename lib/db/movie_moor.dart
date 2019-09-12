import 'dart:convert';

import 'package:cinema_flt/models/movie/movie.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'movie_db.dart';

part 'movie_moor.g.dart';

@UseDao(tables: [Movies])
class MovieMoor extends DatabaseAccessor<MovieDb> with _$MovieMoorMixin {
  MovieMoor(MovieDb db) : super(db);

  Future insertOrReplaceMovie(List<MoviesCompanion> data) =>
      into(movies).insertAll(data);

  Future insertSingleMovie(MoviesCompanion data) =>
      into(movies).insert(data, orReplace: true);

  Future<List<MovieEntry>> getMovieList(
      {bool isUpcoming = false,
      bool isPopuler = false,
      bool isToprate = false}) {
    return (select(movies)
          ..where((t) => t.upcoming.equals(isUpcoming))
          ..where((t) => t.popular.equals(isPopuler))
          ..where((t) => t.topRate.equals(isToprate)))
        .get();
  }

  Future<MovieEntry> getDataMovie(
      {int idMovie,
      bool isUpcoming = false,
      bool isPopuler = false,
      bool isToprate = false}) {
    return (select(movies)
          ..where((t) => t.idMovie.equals(idMovie))
          ..where((t) => t.upcoming.equals(isUpcoming))
          ..where((t) => t.popular.equals(isPopuler))
          ..where((t) => t.topRate.equals(isToprate)))
        .getSingle();
  }

  void insertMovie(
      {List<Movie> datas,
      bool isPopuler = false,
      bool isUpcoming = false,
      bool isTopRate = false}) {
    if (datas.isNotEmpty) {
      datas.forEach((dt) async {
        MoviesCompanion companion = MoviesCompanion(
            video: Value(dt.video),
            posterPath: Value(dt.posterPath),
            idMovie: Value(dt.id),
            voteCount: Value(dt.voteCount),
            popularity: Value(dt.popularity),
            adult: Value(dt.adult),
            backdropPath: Value(dt.backdropPath),
            originalLanguage: Value(dt.originalLanguage),
            originalTitle: Value(dt.originalTitle),
            title: Value(dt.title),
            voteAverage: Value(dt.voteAverage),
            genreIds: Value(dt.genreIds.toString()),
            overview: Value(dt.overview),
            releaseDate: Value(dt.releaseDate),
            upcoming: Value(isUpcoming),
            popular: Value(isPopuler),
            topRate: Value(isTopRate));

        await getDataMovie(
                idMovie: dt.id,
                isPopuler: isPopuler,
                isUpcoming: isUpcoming,
                isToprate: isTopRate)
            .then((dt) {
          if (dt == null) {
            insertSingleMovie(companion);
          }
        });
      });
    }
  }
}
