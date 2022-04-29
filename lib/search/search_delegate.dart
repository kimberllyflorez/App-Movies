import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Buscar Pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    final Movie movies;
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, null)
        //Navigator.pushNamed(context, 'home'),
        );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('$query');
  }

  Widget _EmptyContainer() {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _EmptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        //cuando aqui hay info sera lista de Movie
        if (!snapshot.hasData) return _EmptyContainer();
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, int i) => _MovieItem(snapshot.data![i]));
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search${movie.id}';
    return ListTile(
      leading: FadeInImage(
        placeholder: AssetImage('assets/loading.gif'),
        image: NetworkImage(movie.fullPosterImg),
        fit: BoxFit.fitHeight,
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}
