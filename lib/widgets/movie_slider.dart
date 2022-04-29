import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movie_provider.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie>movies;
  final String? title;
  final Function onNextpage;

  const MovieSlider({
    Key? key,
    required this.movies,
    this.title,
    required this.onNextpage,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = new ScrollController();



  @override
  void initState() {//crea codigo la primera ves q el widg es constr
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        widget.onNextpage();
      }
    });
  }
  @override
  void dispose() {//al final del codig destruye el widget
    // TODO: implement dispose
    super.dispose(

    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
    width: double.infinity,
    height:280,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        //opcional
        if (widget.title != null)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(this.widget.title!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
        ),

        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_,int index,) =>_MoviePoster(widget.movies[index],
                  '${widget.title}-{index}-${widget.movies[index].id}')

          ),
        )
      ],
    ),
    );
  }
}
class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;
  const _MoviePoster(this.movie, this.heroId);

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;
    return Container(
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric(horizontal: 10),
       child: Column(
         children: [

           GestureDetector(
             onTap: ()=> Navigator.pushNamed
               (context, 'details',arguments: movie),
             child: Hero(
               tag: movie.heroId!,
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(20),
                 child: FadeInImage(
                     placeholder: AssetImage('assets/no-image.jpg'),
                     image: NetworkImage(movie.fullPosterImg),
                     width: 130,
                   height: 190,
                   fit: BoxFit.cover,
                 ),
               ),
             ),
           ),
           SizedBox(height: 5),
           Text(movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
             textAlign:TextAlign.center,
           ),
      ],
    ),
    );
  }
}
