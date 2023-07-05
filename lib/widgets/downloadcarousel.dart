// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmfusion/widgets/landingcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DownloadCarousel extends StatelessWidget {
  // final List<String> images;
  // final String name;
  DownloadCarousel(this.data, {Key? key}) : super(key: key) {
    // //Step 1.2:Get the reference of the document
    // _documentReference = FirebaseFirestore.instance
    //     .collection('downloadData')
    //     .doc('GOcpx8SePYcaBU33ejAU');
    // //Step 2.2:Get the reference of the comments collection
    // _referenceComments = _documentReference.collection('NewMovieCarosuel');
    // //Step 5.2:Get the stream
    // _streamComments = _referenceComments.snapshots();
  }
  late dynamic data;
  // late DocumentReference
  //     _documentReference; //Step 1.1: Create field for the document reference
  // late CollectionReference
  //     _referenceComments; //Step 2.1: Create field for the comments collection
  // late Stream<QuerySnapshot>
  //     _streamComments; //Step 5.1: Create fiels for the comments stream

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        pageSnapping: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var thisComment = data[index];
          // final newMovie = newMovies[index];
          print(data.length);
          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
            },
            child: LandingCard(
              image: CachedNetworkImageProvider(
                thisComment['image'],
              ),
              name: thisComment['name'],
            ),
          );
        },
      ),
    );
  }
}
