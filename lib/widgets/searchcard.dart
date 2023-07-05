import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final String title;
  final ImageProvider image;
  final String popularRating;
  final String mediaType;
  const SearchCard(
      {super.key,
      required this.title,
      required this.image,
      required this.popularRating,
      required this.mediaType});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: 100,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                width: size.width - 150,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                width: size.width - 150,
                child: Row(
                  children: [
                    const Text(
                      'Media Type:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      mediaType.toString().toString(),
                      style: TextStyle(
                        color: accent_secondary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                width: size.width - 150,
                child: Row(
                  children: [
                    Text(
                      mediaType == 'person' ? 'Popularity:' : 'Rating:',
                      style: TextStyle(
                        color: accent_secondary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      popularRating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
