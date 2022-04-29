import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debounce.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/models/popular_response.dart';
import 'package:movies_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  //se tiene acceso widgetsproviders
  //para que sea provider valio hay que extends

  final _apiKey = '5c20e185c4e1027dbc3b61276f2c451d';
  final _baseUrl = 'api.themoviedb.org';
  final _language = 'es-ES';

  List<Movie> onDisplayMovie = [];
  List<Movie> onDisplayPopularMovie = [];
  Map<int, List<Cast>> moviesCast = {}; //int es id de la pel
  List<Movie> searchMovie = [];
  int _intPopularPage = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
//se inicializa el provider ..IMPORTANTE..INICIALKIZA LA PETICION PARA MOSTRAR PANT
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String segmento, [int page = 1]) async {
    //optimizar codigo crea metodo privado.
    // para que reciba valor opcional entre llaves cuadradas
    final url = //CREA URL
    Uri.https(_baseUrl, segmento, {
      //esto sera un mapa con parametros que yo quiera
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }


//es un metodo independiente
  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');
    //SE REALIZA PETICION HTTPS
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovie = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _intPopularPage++;
    final jsonData =
        await this._getJsonData('3/movie/popular', _intPopularPage);
    final popularResult = PopularResponse.fromJson(jsonData);
    onDisplayPopularMovie = [...popularResult.results];

    //aqui se desestructura para hacer paginacion
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final decodeData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResult =
        CreditsResponse.fromJson(decodeData); //aqui ya esta la info de cast
    moviesCast[movieId] = creditsResult.cast;
    return creditsResult.cast; //esto de dispara en del credits cards
  }

  //com el future<xx> especifica el tipo de retorno
  Future<List<Movie>> searchMovies(String query) async {
    //query es termino de busqueda

    final url = //CREA URL(se define como tal la peticion)
        Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url); //aqui se hace llamado peticion
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //es asinc por que aqui se llamara el searchmiv
      print('tenemos valor a buscar: $value');
      final result = await this.searchMovies(value);//aqui tenemos resuktados
      this._suggestionStreamController.add(result);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      //se ejecuta x tiemp
      debouncer.value = searchTerm; // cada 200mils se envia este searTher
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
