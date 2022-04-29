import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';

import '../widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {

  const DetailsScreen ({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //nstancia de movie
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    //el as Movie no conv la dara solo le dice como se trata ese obj q trae

    return Scaffold(
      body: CustomScrollView(
       slivers: [
         _CustomAppBar(movie),
         SliverList(
             delegate: SliverChildListDelegate([
               _PosterAndTitle(movie: movie),
               _overview(movie: movie),
               CastingCards(movieId: movie.id,),
          ])
         )
       ],
      ),
    );
  }
}
class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar(this.movie);
  @override
  Widget build(BuildContext context) {

    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(0),
        centerTitle: true,
        title: Container(
          color: Colors.black12,
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Text(movie.title),
          padding: EdgeInsets.only(bottom: 10, right: 10, left: 10 ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif') ,
          image: NetworkImage(movie.fullbackdropPath),//'https://via.placeholder.com/500x300'
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({Key? key,
    required this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal:20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullbackdropPath), fit: BoxFit.cover,
                  height: 150,
                  width: 120,
              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                  style: textTheme.headline5,
                overflow: TextOverflow.ellipsis,
                ),
                Text(movie.originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 5),
                    Text(movie.voteAverage.toString(),
                      style: textTheme.caption),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _overview extends StatelessWidget {
  final Movie movie;
  const _overview({Key? key,
    required this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(movie.overview,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1
      ),
    );
  }
}

