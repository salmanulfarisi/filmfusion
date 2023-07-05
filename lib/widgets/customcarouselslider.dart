import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmfusion/models/TvShow.dart';
import 'package:filmfusion/widgets/landingcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CustomCarouselSlider extends StatelessWidget {
  final List<TvShow> data;
  const CustomCarouselSlider({super.key, required this.data});

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
        itemCount: 20,
        itemBuilder: (context, index) {
          var url = data[index].backdropPath.toString();
          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              GoRouter.of(context).push('/tv/${data[index].id}');
            },
            child: LandingCard(
              image: CachedNetworkImageProvider(
                "https://image.tmdb.org/t/p/original$url",
              ),
              name: data[index].name.toString(),
            ),
          );
        },
      ),
    );
  }
}
