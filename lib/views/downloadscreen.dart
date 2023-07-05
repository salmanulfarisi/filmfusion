import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:filmfusion/views/allmoviesections.dart';
import 'package:filmfusion/widgets/bottomnavbar.dart';
import 'package:filmfusion/widgets/downloadcarousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool isLoading = true;
  late DocumentReference
      _documentReference; //Step 1.1: Create field for the document reference
  late CollectionReference
      _referenceComments; //Step 2.1: Create field for the comments collection
  late Stream<QuerySnapshot> _streamComments;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(listen);
    //Step 1.2:Get the reference of the document
    _documentReference = FirebaseFirestore.instance
        .collection('downloadData')
        .doc('GOcpx8SePYcaBU33ejAU');
    //Step 2.2:Get the reference of the comments collection
    _referenceComments = _documentReference.collection('NewMovieCarosuel');
    //Step 5.2:Get the stream
    _streamComments = _referenceComments.snapshots();
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
              child: BottomNavBar(currentIndex: 2));
        },
      ),
      extendBody: true,
      body: Container(
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
                final QuerySnapshot<Map<String, dynamic>> data = snapshot.data!;
                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    documents = data.docs;
                final List items = documents
                    .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                        doc['newMovie'])
                    .expand((list) => list)
                    .toList();
                // final List items = documents
                //     .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                //         doc['newMovie'])
                //     .expand((list) => list)
                //     .toList();
                return DownloadCarousel(items);
              },
            ),
            // DownloadCarousel(data: const {'id': '1'}
            //     // images: [
            //     //   'https://static.moviecrow.com/gallery/20230327/213822-live.jpg',
            //     //   'https://th-i.thgim.com/public/entertainment/movies/eprij8/article66907308.ece/alternates/FREE_1200/Kerala%20Crime%20Files.jpg',
            //     //   'https://images.cinemaexpress.com/uploads/user/imagelibrary/2023/3/19/original/FirstlookposterofJacksonBazaarYouthisout.jpg',
            //     //   'https://img.onmanorama.com/content/dam/mm/en/entertainment/movie-reviews/images/2023/5/26/thrishanku-movie.jpg',
            //     //   'https://c.ndtvimg.com/2023-04/be5jquoo_pooja-hegde_625x300_08_April_23.jpg',
            //     //   'https://www.nowrunning.com/content/movie/2021/karun-25810/bg_karungaapiyam.jpg',
            //     // ],
            //     // name: 'Movie Name',
            //     ),
            InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllMovieSections()));
              },
              child: ContainerWithText(
                size: size,
                title: 'Latest HD movies',
              ),
            ),
            ContainerWithText(
              size: size,
              title: 'How to Download',
            ),
            ContainerWithText(
              size: size,
              title: 'Buy Best Products',
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerWithText extends StatelessWidget {
  const ContainerWithText({super.key, required this.size, required this.title});

  final Size size;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: accent_t.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
