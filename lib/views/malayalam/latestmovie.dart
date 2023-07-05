import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicons/unicons.dart';

class LatestMalayalamMovie extends StatelessWidget {
  LatestMalayalamMovie({Key? key}) : super(key: key) {
    //Step 1.2:Get the reference of the document
    _documentReference = FirebaseFirestore.instance
        .collection('downloadData')
        .doc('GOcpx8SePYcaBU33ejAU');
    //Step 2.2:Get the reference of the comments collection
    _referenceMovie = _documentReference.collection('LatestMalayalam');

    //Step 5.2:Get the stream
    _streamComments = _referenceMovie.snapshots();
  }
  // late dynamic data;
  late DocumentReference
      _documentReference; //Step 1.1: Create field for the document reference
  late CollectionReference _referenceMovie;
  late CollectionReference
      _referenceSize; //Step 2.1: Create field for the comments collection
  late Stream<QuerySnapshot>
      _streamComments; //Step 5.1: Create fiels for the comments stream

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background_primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Latest 2023 Malayalam Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                    final QuerySnapshot<Map<String, dynamic>> data =
                        snapshot.data!;
                    final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        documents = data.docs;
                    final List items = documents
                        .map(
                            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                                doc['latestMalayalam'])
                        .expand((list) => list)
                        .toList();

                    return GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.6,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        items.length,
                        (index) {
                          var sizes = items[index]['sizes_and_link'];
                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                // margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        items[index]['movie_poster']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[index]['movie_name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            items[index]['movie_format'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              HapticFeedback.mediumImpact();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          background_primary,
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Choose File Size',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                          Divider(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ],
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: List.generate(
                                                            items[index][
                                                                    'sizes_and_link']
                                                                .length,
                                                            (index) {
                                                          print(items[index][
                                                                  'sizes_and_link']
                                                              .length);

                                                          return LinkContainer(
                                                            title: sizes[index]
                                                                ['size'],
                                                          );
                                                        }),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Icon(
                                              UniconsLine.cloud_download,
                                              color: inactive_accent,
                                              size: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinkContainer extends StatelessWidget {
  final String title;

  const LinkContainer({
    super.key,
    this.title = 'Link',
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          const Spacer(),
          const Icon(UniconsLine.link),
        ],
      ),
    );
  }
}
