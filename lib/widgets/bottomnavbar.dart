import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unicons/unicons.dart';

class BottomNavBar extends StatefulWidget {
  int currentIndex = 0;
  BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      decoration: BoxDecoration(
        color: accent_t.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  widget.currentIndex = 0;
                });
                GoRouter.of(context).go('/main');
              },
              icon: Icon(
                UniconsLine.home_alt,
                color:
                    widget.currentIndex == 0 ? Colors.white : inactive_accent,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  widget.currentIndex = 1;
                });
                GoRouter.of(context).go('/search');
              },
              icon: Icon(
                UniconsLine.search,
                color:
                    widget.currentIndex == 1 ? Colors.white : inactive_accent,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  widget.currentIndex = 2;
                });
                GoRouter.of(context).go('/download');
              },
              icon: Icon(
                UniconsLine.download_alt,
                color:
                    widget.currentIndex == 2 ? Colors.white : inactive_accent,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  widget.currentIndex = 3;
                });
                GoRouter.of(context).go('/profile');
              },
              icon: Icon(
                UniconsLine.user,
                color:
                    widget.currentIndex == 3 ? Colors.white : inactive_accent,
              )),
        ],
      ),
    );
  }
}
