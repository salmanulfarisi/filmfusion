import 'package:filmfusion/models/MovieDetail.dart';
import 'package:filmfusion/models/TvShowDetail.dart';
import 'package:filmfusion/services/api.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class WatchListScreen extends StatefulWidget {
  final List watchList;
  final String status;
  const WatchListScreen(
      {super.key, required this.watchList, required this.status});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.status,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        backgroundColor: background_primary,
        elevation: 0,
      ),
      backgroundColor: background_primary,
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.watchList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: watchListItem(widget.watchList[index]['Id'],
                  widget.watchList[index]['mediaType'], context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

Future<Widget> watchListItem(String id, String mediaType, context) async {
  MovieDetail details;
  if (mediaType == 'movie') {
    details = await APIService().getMovieDetail(id);
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        GoRouter.of(context).push('/movie/$id');
      },
      child: SizedBox(
        child: Row(
          children: [
            Container(
              height: 150,
              width: 100,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${details.posterPath}'),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    details.title ?? 'No Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  'Release Date: ${details.releaseDate}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Rating: ${details.voteAverage.toString().substring(0, 3)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                const Text(
                  'Type: Movie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                )
              ],
            )
          ],
        ),
      ),
    );
  } else {
    TvShowDetail showDetails = await APIService().getTvShowDetail(id);
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        GoRouter.of(context).push('/tv/$id');
      },
      child: Container(
        child: Row(
          children: [
            Container(
              height: 150,
              width: 100,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500${showDetails.posterPath}',
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(showDetails.name!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left),
                Text("First Air Date: ${showDetails.firstAirDate}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left),
                Text(
                    "Rating: ${showDetails.voteAverage.toString().substring(0, 3)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left),
                const Text("Type: TV Show",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left),
              ],
            )
          ],
        ),
      ),
    );
  }
}
