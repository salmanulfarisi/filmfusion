import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';

class LandingCard extends StatelessWidget {
  final ImageProvider image;
  final String name;
  const LandingCard({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      width: size.width,
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
            decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                background_primary.withOpacity(0.50),
                background_primary.withOpacity(0.75),
                background_primary.withOpacity(1.00),
              ],
            )),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  background_primary.withOpacity(0.80),
                  background_primary.withOpacity(0.60),
                  background_primary.withOpacity(0.40),
                  Colors.transparent
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            alignment: Alignment.bottomCenter,
            width: size.width,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
