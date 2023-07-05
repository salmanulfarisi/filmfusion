import 'package:filmfusion/models/TvShow.dart';
import 'package:filmfusion/models/popular_movies_model.dart';
import 'package:filmfusion/services/api.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:filmfusion/widgets/bottomnavbar.dart';
import 'package:filmfusion/widgets/customcarouselslider.dart';
import 'package:filmfusion/widgets/customlistmovie.dart';
import 'package:filmfusion/widgets/loadingscreen.dart';
import 'package:filmfusion/widgets/sectiontext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

ValueNotifier<List<Results>> langanuageMovie = ValueNotifier<List<Results>>([]);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool isLoading = true;

  late List<Results> popularMovies;
  late List<Results> topRatedMovie;
  late List<Results> nowPLayingMovie;
  late List<TvShow> popularShows;
  late List<TvShow> topRatedShows;
  //  List<Results> languageMovie;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController = ScrollController();
    _scrollController.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(listen);
    _scrollController.dispose();
  }

  void listen() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      (setState(
        () => isVisible = true,
      ));
    }
  }

  void hide() {
    if (isVisible) {
      (setState(
        () => isVisible = false,
      ));
    }
  }

  Future<void> fetchData() async {
    topRatedShows = await APIService().getTopRatedShow();
    popularMovies = await APIService().getPopularMovies();
    topRatedMovie = await APIService().getTopRatedMovie();
    popularShows = await APIService().getRecommendedTvShows('1396');
    nowPLayingMovie = await APIService().getNowPLayingMovie();
    // langanuageMovie.value = await APIService().getMovieLanguage();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.fastLinearToSlowEaseIn,
              height: isVisible ? 75 : 0,
              child: BottomNavBar(currentIndex: 0));
        },
      ),
      extendBody: true,
      body: isLoading
          ? const LoadingScreen()
          : Container(
              height: size.height,
              width: size.width,
              color: background_primary,
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                shrinkWrap: true,
                children: [
                  CustomCarouselSlider(data: topRatedShows),
                  sectionText('Popular', 'Movies'),
                  CustomListMovie(popularMovies: popularMovies),
                  sectionText('TOP Rated', 'Movies'),
                  CustomListMovie(popularMovies: topRatedMovie),
                  sectionText('Popular', 'Shows'),
                  CustomListTv(data: popularShows),
                  sectionText('NOW Playing', 'Movies'),
                  CustomListMovie(popularMovies: nowPLayingMovie),
                  // ValueListenableBuilder(
                  //   valueListenable: languageNotifier,
                  //   builder: (context, value, child) {
                  //     return sectionText('NOW in', value.name);
                  //   },
                  // ),
                  // ValueListenableBuilder(
                  //   valueListenable: langanuageMovie,
                  //   builder: (context, value, child) {
                  //     return CustomListMovie(
                  //         popularMovies: langanuageMovie.value);
                  //   },
                  // )
                ],
              ),
            ),
    );
  }
}
