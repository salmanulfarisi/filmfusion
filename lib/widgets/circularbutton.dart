import 'package:flutter/material.dart';

Widget circularButton(IconData icon, {required Function() onTap}) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(top: 8, right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF23232B).withOpacity(0.60),
        border: Border.all(width: 0.75, color: const Color(0xFF373741)),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Icon(
          icon,
          color: const Color(0xFF9D9DA5),
        ),
      ),
    ),
  );
}
