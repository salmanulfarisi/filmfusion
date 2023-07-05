import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';

Widget sectionText(String title, String subtitle) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 5,
            ),
          ),
        ),
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            color: accent_secondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 5,
          ),
        )
      ],
    ),
  );
}
