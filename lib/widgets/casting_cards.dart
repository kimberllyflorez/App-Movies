

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({
    Key? key,
    required this.movieId,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider =  Provider.of<MoviesProvider>(context, listen: false);
    //TRAE LA INSTANCIA DEL PROVIDER PARA USARLA EN EL FUTUREBULDER, LIST NO REDIB

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),//el que esta en el PROVIDER
      builder:( _, AsyncSnapshot<List<Cast>> snapshot){
        if (!snapshot.hasData){
          return Container(
            constraints:BoxConstraints(maxWidth: 300),
            height: 160,
            child: CupertinoActivityIndicator(),
          );
        }
        final List<Cast> cast = snapshot.data!;
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 160,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (_, int i) => _CastCard( actor: cast[i]),

          ),
        );

      },
    );

  }
}
class _CastCard extends StatelessWidget {
final Cast actor;

  const _CastCard({Key? key,
    required this.actor,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 120,
              width: 100,
              fit: BoxFit.cover,

          ),
          ),
          Text(actor.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          ),

        ],
      )
    );
  }
}
