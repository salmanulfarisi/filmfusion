import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filmfusion/models/EpisodeDetail.dart';
import 'package:filmfusion/models/MovieDetail.dart';
import 'package:filmfusion/models/SearchResult.dart';
import 'package:filmfusion/models/TvShow.dart';
import 'package:filmfusion/models/TvShowDetail.dart';
import 'package:filmfusion/models/VideoDetails.dart';
import 'package:filmfusion/models/popular_movies_model.dart';
import 'package:filmfusion/services/key.dart';

class APIService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'api_key=$api_key';

  Future<List<Results>> getPopularMovies() async {
    try {
      List<Results> movieList = [];
      final url = '$baseUrl/movie/popular?$apiKey&page=1';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      movieList = movies.map((m) => Results.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  // Future<List<Results>> getMovieLanguage() async {
  //   try {
  //     List<Results> movieList = [];
  //     final url = '$baseUrl/movie/now_playing?&language=ml-IN&$apiKey&page=1';
  //     final response = await _dio.get(url);
  //     var movies = response.data['results'] as List;
  //     movieList = movies.map((m) => Results.fromJson(m)).toList();
  //     return movieList;
  //   } catch (error, stacktrace) {
  //     throw Exception('Exception occured: $error with stacktrace: $stacktrace');
  //   }
  // }

  Future<List<Results>> getTopRatedMovie() async {
    try {
      List<Results> movieList = [];
      final url = '$baseUrl/movie/top_rated?$apiKey&page=1';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      movieList = movies.map((m) => Results.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Results>> getRecommendedMovie(String movieId) async {
    try {
      List<Results> movieList = [];
      final url = '$baseUrl/movie/$movieId/recommendations?$apiKey&page=1';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      movieList = movies.map((m) => Results.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieDetail> getMovieDetail(String movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId?$apiKey';
      final response = await _dio.get(url);
      MovieDetail movie = MovieDetail.fromJson(response.data);
      return movie;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Genres>> getMovieGeneres(String movieId, String mediaType) async {
    try {
      List<Genres> generesList = [];
      final url = '$baseUrl/$mediaType/$movieId?$apiKey';
      final response = await _dio.get(url);
      var generes = response.data['genres'] as List;
      generesList = generes.map((m) => Genres.fromJson(m)).toList();
      return generesList;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Results>> getNowPLayingMovie() async {
    try {
      List<Results> movieList = [];
      final url = '$baseUrl/movie/now_playing?$apiKey&page=1';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      movieList = movies.map((m) => Results.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // TV Shows

  Future<List<TvShow>> getPopularShow() async {
    try {
      List<TvShow> showsList = [];
      final url = '$baseUrl/tv/popular?$apiKey&page=1';
      final response = await _dio.get(url);
      var shows = response.data['results'] as List;
      showsList = shows.map((m) => TvShow.fromJson(m)).toList();
      return showsList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<TvShow>> getTopRatedShow() async {
    try {
      List<TvShow> showsList = [];
      final url = '$baseUrl/tv/top_rated?$apiKey&page=1';
      final response = await _dio.get(url);
      var shows = response.data['results'] as List;
      showsList = shows.map((m) => TvShow.fromJson(m)).toList();
      return showsList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<TvShow>> getRecommendedTvShows(String showId) async {
    try {
      List<TvShow> showList = [];
      final url = '$baseUrl/tv/$showId/recommendations?$apiKey&page=1';
      final response = await _dio.get(url);
      var shows = response.data['results'] as List;
      showList = shows.map((m) => TvShow.fromJson(m)).toList();
      return showList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<TvShowDetail> getTvShowDetail(String showId) async {
    try {
      final url = '$baseUrl/tv/$showId?$apiKey';
      final response = await _dio.get(url);
      TvShowDetail show = TvShowDetail.fromJson(response.data);
      return show;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Episodes>> getEpisodes(String showID, String seasonNum) async {
    try {
      List<Episodes> episodeList = [];
      final url = '$baseUrl/tv/$showID/season/$seasonNum?$apiKey';
      final response = await _dio.get(url);
      var shows = response.data['episodes'] as List;
      episodeList = shows.map((m) => Episodes.fromJson(m)).toList();
      return episodeList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // Search

  Future<List<SearchResult>> getSearchResult(searchQuery) async {
    if (searchQuery.toString().isEmpty) {
      return [];
    }
    try {
      final url = '$baseUrl/search/multi?$apiKey&query=$searchQuery';
      final response = await _dio.get(url);
      var shows = response.data['results'] as List;
      List<SearchResult> showsList =
          shows.map((m) => SearchResult.fromJson(m)).toList();
      return showsList;
    } catch (error) {
      return [];
    }
  }

  // trailer Link

  Future<String> getTrailerLink(String movieId, String mediaType) async {
    try {
      final url = '$baseUrl/$mediaType/$movieId/videos?$apiKey';
      final response = await _dio.get(url);
      var videos = response.data['results'] as List;
      List<VideoResults> videosList =
          videos.map((m) => VideoResults.fromJson(m)).toList();
      var trailerLink = 'dQw4w9WgXcQ'; // Rick Roll
      for (var i = 0; i < videosList.length; i++) {
        if (videosList[i].site == 'YouTube' &&
            videosList[i].type == 'Trailer') {
          trailerLink = videosList[i].key.toString();
        }
      }
      return 'https://www.youtube.com/watch?v=$trailerLink';
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

// Get a reference to the parent collection
  CollectionReference parentCollectionRef =
      FirebaseFirestore.instance.collection('downloadData');

// Query the nested collection
}
