import 'package:flutter/material.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);//aqui se le dice q prov buscar

    return Scaffold(
      appBar: AppBar(
        title: Text('peliculas'),
        actions: [
          IconButton(
              onPressed: ()=> showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: Icon( Icons.search))],
      ),
      body: Column(
        children: [
          //tarjetas
          CardSwiper(movies: moviesProvider.onDisplayMovie),
          //slider de peliculas
          MovieSlider(
            title: 'POPULARES',
            movies: moviesProvider.onDisplayPopularMovie,
            onNextpage: () => moviesProvider.getPopularMovies(),
          ),
        ],
        ),
    );
  }
}
