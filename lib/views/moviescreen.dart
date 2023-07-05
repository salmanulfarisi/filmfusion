import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfusion/models/popular_movies_model.dart';
import 'package:filmfusion/services/api.dart';
import 'package:filmfusion/services/extraservice.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:filmfusion/widgets/circularbutton.dart';
import 'package:filmfusion/widgets/customlistmovie.dart';
import 'package:filmfusion/widgets/loadingscreen.dart';
import 'package:filmfusion/widgets/textcontainer.dart';
import 'package:filmfusion/widgets/titletext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

class MovieScreen extends StatefulWidget {
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  bool isLoading = true;
  late List<Results> recommendedMovies;
  late DocumentReference
      _documentReference; //Step 1.1: Create field for the document reference
  late CollectionReference _referenceMovie;
  late CollectionReference
      _referenceSize; //Step 2.1: Create field for the comments collection
  late Stream<QuerySnapshot> _streamComments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    _documentReference = FirebaseFirestore.instance
        .collection('downloadData')
        .doc('GOcpx8SePYcaBU33ejAU');
    //Step 2.2:Get the reference of the comments collection
    _referenceMovie = _documentReference.collection('LatestMalayalam');

    //Step 5.2:Get the stream
    _streamComments = _referenceMovie.snapshots();
  }

  Future<void> fetchData() async {
    recommendedMovies = await APIService().getRecommendedMovie(widget.movieId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background_primary,
      body: isLoading
          ? const LoadingScreen()
          : FutureBuilder(
              future: APIService().getMovieDetail(widget.movieId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var status = snapshot.data!.status.toString();
                  var releaseDate = snapshot.data!.releaseDate.toString();
                  return ListView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: size.height * 0.40 > 300
                                ? size.height * 0.40
                                : 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: snapshot.data!.backdropPath == null
                                  ? const AssetImage('assets/LoadingImage.png')
                                      as ImageProvider
                                  : NetworkImage(
                                      "https://image.tmdb.org/t/p/original${snapshot.data!.backdropPath}"),
                              fit: BoxFit.cover,
                            )),
                          ),
                          Container(
                            width: size.width,
                            height: size.height * 0.40 > 300
                                ? size.height * 0.40
                                : 300,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                background_primary.withOpacity(0.50),
                                background_primary.withOpacity(0.75),
                                background_primary.withOpacity(0.90),
                                background_primary.withOpacity(1.00),
                              ],
                            )),
                          ),
                          Container(
                            width: size.width,
                            height: size.height * 0.35 > 300
                                ? size.height * 0.35
                                : 300,
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.data!.voteAverage
                                      .toString()
                                      .substring(0, 3),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.title.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                StreamBuilder(
                                  stream: _streamComments,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    final QuerySnapshot<Map<String, dynamic>>
                                        data = snapshot.data!;
                                    final List<
                                            QueryDocumentSnapshot<
                                                Map<String, dynamic>>>
                                        documents = data.docs;
                                    final List items = documents
                                        .map((QueryDocumentSnapshot<
                                                    Map<String, dynamic>>
                                                doc) =>
                                            doc['latestMalayalam'])
                                        .expand((list) => list)
                                        .toList();
                                    return Row(
                                      children: [
                                        circularButton(
                                          UniconsLine.play,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            APIService()
                                                .getTrailerLink(
                                                    snapshot.data!.id
                                                        .toString(),
                                                    "movie")
                                                .then((value) =>
                                                    launchUrls(value));
                                          },
                                        ),
                                        circularButton(
                                          UniconsLine.plus,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            pshowDialog(context, widget.movieId,
                                                'movie');
                                          },
                                        ),
                                        Visibility(
                                          visible: snapshot.data!.adult,
                                          child: circularButton(
                                            UniconsLine.eighteen_plus,
                                            onTap: () {},
                                          ),
                                        ),
                                        Visibility(
                                            visible: documents.contains(
                                                    snapshot.data.id) ==
                                                widget.movieId,
                                            child: circularButton(
                                              UniconsLine.eighteen_plus,
                                              onTap: () {},
                                            ))
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      FutureBuilder(
                        future: APIService()
                            .getMovieGeneres(widget.movieId, 'movie'),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 36,
                              width: size.width,
                              margin: const EdgeInsets.only(left: 8),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return textContainer(
                                      snapshot.data![index].name.toString(),
                                      const EdgeInsets.only(right: 8),
                                      const Color(0xFF14303B));
                                },
                              ),
                            );
                          } else {
                            return textContainer(
                                'Loading',
                                const EdgeInsets.only(right: 8),
                                const Color(0xFF14303B));
                          }
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleText('Status'),
                          Row(
                            children: [
                              textContainer(
                                status,
                                const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                const Color(0xFF382E39),
                              ),
                              textContainer(
                                'Release : ${DateFormat.yMMMMd().format(DateTime.parse(releaseDate))}',
                                const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                const Color(0xFF545551),
                              ),
                            ],
                          ),
                          titleText('Overview'),
                          textContainer(
                            snapshot.data!.overview.toString().isEmpty ||
                                    snapshot.data!.overview.toString() == 'null'
                                ? 'No overview available :('
                                : snapshot.data!.overview.toString(),
                            const EdgeInsets.all(8),
                            const Color(0xFF0F1D39),
                          ),
                          titleText('Recommendations'),
                          CustomListMovie(popularMovies: recommendedMovies)
                        ],
                      )
                    ],
                  );
                }
                return const LoadingScreen();
              },
            ),
    );
  }
}
