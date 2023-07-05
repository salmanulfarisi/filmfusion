import 'package:filmfusion/services/api.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:filmfusion/widgets/bottomnavbar.dart';
import 'package:filmfusion/widgets/searchlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:unicons/unicons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isVisible = true;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  final myController = TextEditingController();
  String query = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(listen);
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
      setState(() {
        isVisible = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
    _scrollController.removeListener(listen);
    _scrollController.dispose();
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        GoRouter.of(context).go('/main');
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: background_primary,
        bottomNavigationBar: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.fastLinearToSlowEaseIn,
              height: isVisible ? 75 : 0,
              child: BottomNavBar(currentIndex: 1),
            );
          },
        ),
        extendBody: true,
        body: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Image.asset(
              'assets/backdrop.png',
              fit: BoxFit.fitWidth,
              width: size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(8, 28, 8, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: accent_t.withOpacity(0.95),
                  ),
                  child: TextField(
                    controller: myController,
                    cursorColor: accent_secondary,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        UniconsLine.search,
                        color: Colors.white,
                      ),
                      prefixIconColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = myController.text;
                      });
                    },
                  ),
                ),
                SearchList(
                    future: APIService().getSearchResult(query),
                    scrollController: _scrollController),
              ],
            ),
            if (query == "")
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/No_data.json',
                      width: size.width * 0.60,
                      frameRate: FrameRate(60),
                    ),
                    Text(
                      'Search for your favorite movies and shows!',
                      style: TextStyle(
                        color: inactive_accent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
