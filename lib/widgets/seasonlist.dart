import 'package:filmfusion/services/api.dart';
import 'package:flutter/material.dart';

class SeasonList extends StatefulWidget {
  final int seasonNumber;
  final String movieId;
  const SeasonList(
      {super.key, required this.seasonNumber, required this.movieId});

  @override
  State<SeasonList> createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: FutureBuilder(
        future: APIService()
            .getEpisodes(widget.movieId, widget.seasonNumber.toString()),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var url = snapshot.data[index].stillPath.toString();
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF14303B).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFA3A3B0).withOpacity(0.5),
                        width: 0.75,
                      )),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 200,
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: url == 'null'
                                ? const AssetImage('assets/LoadingImage.png')
                                    as ImageProvider
                                : NetworkImage(
                                    "https://image.tmdb.org/t/p/w500$url"),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            snapshot.data[index].episodeNumber.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                    color: Colors.black,
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8, top: 4),
                        width: 200,
                        child: Text(
                          snapshot.data[index].name.toString(),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
