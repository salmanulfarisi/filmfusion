import 'package:flutter/material.dart';

Widget titleText(data) {
  return Container(
    margin: const EdgeInsets.all(8),
    child: Text(
      data,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  );
}
