import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmfusion/models/SearchResult.dart';
import 'package:filmfusion/widgets/searchcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SearchList extends StatefulWidget {
  final ScrollController scrollController;
  final Future<List<SearchResult>> future;
  const SearchList(
      {super.key, required this.scrollController, required this.future});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: size.height * 0.8,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (snapshot.data![index].mediaType == 'movie') {
                  var url = snapshot.data![index].posterPath;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      GoRouter.of(context)
                          .push('/movie/${snapshot.data![index].id}');
                    },
                    child: SearchCard(
                      title: snapshot.data![index].title.toString(),
                      image: url == null
                          ? const AssetImage("assets/LoadingImage.png")
                          : CachedNetworkImageProvider(
                                  "https://image.tmdb.org/t/p/original$url")
                              as ImageProvider,
                      popularRating:
                          snapshot.data![index].voteAverage.toString(),
                      mediaType: 'movie',
                    ),
                  );
                } else if (snapshot.data![index].mediaType == 'tv') {
                  var url = snapshot.data![index].posterPath;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      GoRouter.of(context)
                          .push('/tv/${snapshot.data![index].id}');
                    },
                    child: SearchCard(
                      title: snapshot.data![index].name.toString(),
                      image: url == null
                          ? const AssetImage("assets/LoadingImage.png")
                          : CachedNetworkImageProvider(
                                  "https://image.tmdb.org/t/p/original$url")
                              as ImageProvider,
                      popularRating:
                          snapshot.data![index].voteAverage.toString(),
                      mediaType: 'tv',
                    ),
                  );
                } else if (snapshot.data![index].mediaType == 'person') {
                  var url = snapshot.data![index].profilePath;
                  return SearchCard(
                    title: snapshot.data![index].name.toString(),
                    image: url == null
                        ? const AssetImage("assets/LoadingImage.png")
                        : CachedNetworkImageProvider(
                                "https://image.tmdb.org/t/p/original$url")
                            as ImageProvider,
                    popularRating: snapshot.data![index].popularity.toString(),
                    mediaType: 'person',
                  );
                } else {
                  return const SearchCard(
                    title: 'Loading',
                    image: AssetImage('assets/LoadingImage.png'),
                    popularRating: '0',
                    mediaType: 'N/A',
                  );
                }
              },
            ),
          );
        } else {
          return const SearchCard(
            title: 'Loading',
            image: AssetImage('assets/LoadingImage.png'),
            popularRating: '0',
            mediaType: 'N/A',
          );
        }
      },
    );
  }
}
