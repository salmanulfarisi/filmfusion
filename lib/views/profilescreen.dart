import 'dart:ui';

import 'package:filmfusion/services/auth.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:filmfusion/views/watchlistscreen.dart';
import 'package:filmfusion/widgets/bottomnavbar.dart';
import 'package:filmfusion/widgets/loadingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool isLoading = true;
  late List watchList;
  List completed = [];
  List watching = [];
  List onHold = [];
  List dropped = [];

  @override
  void initState() {
    super.initState();
    fetchData();
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

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  void fetchData() async {
    watchList = await FireBaseServices().getWatchList();
    for (var i = 0; i < watchList.length; i++) {
      if (watchList[i]['status'] == 'Completed') {
        completed.add(watchList[i]);
      } else if (watchList[i]['status'] == 'Watching') {
        watching.add(watchList[i]);
      } else if (watchList[i]['status'] == 'On-Hold') {
        onHold.add(watchList[i]);
      } else if (watchList[i]['status'] == 'Dropped') {
        dropped.add(watchList[i]);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  final User _user = FirebaseAuth.instance.currentUser!;
  String movieLan = LanguageType.English.toString().split('.').last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastLinearToSlowEaseIn,
            height: isVisible ? 75 : 0,
            child: BottomNavBar(
              currentIndex: 3,
            ),
          );
        },
      ),
      backgroundColor: background_primary,
      extendBody: true,
      body: isLoading
          ? const LoadingScreen()
          : Container(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(top: 0),
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(_user.photoURL!.toString()),
                        )
                            // todo: add user profile image
                            ),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: NetworkImage(
                                  _user.photoURL!.toString(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            child: Text(
                              _user.displayName!.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.logout();
                            GoRouter.of(context).pushReplacement('/');
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.only(
                              right: 25,
                              bottom: 200,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14303B).withOpacity(0.25),
                              border: Border.all(
                                color:
                                    const Color(0xFF14303B).withOpacity(0.25),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (watching.isEmpty) {
                                  HapticFeedback.mediumImpact();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchListScreen(
                                        watchList: watching,
                                        status: 'Watching',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: watchListTile(
                                  watching.length.toString(), 'Watching'),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (completed.isEmpty) {
                                  HapticFeedback.mediumImpact();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchListScreen(
                                        watchList: completed,
                                        status: 'Completed',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: watchListTile(
                                  completed.length.toString(), 'Completed'),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (onHold.isEmpty) {
                                  HapticFeedback.mediumImpact();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchListScreen(
                                        watchList: onHold,
                                        status: 'On-Hold',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: watchListTile(
                                  onHold.length.toString(), 'OnHold'),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (dropped.isEmpty) {
                                  HapticFeedback.mediumImpact();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchListScreen(
                                        watchList: dropped,
                                        status: 'Dropped',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: watchListTile(
                                  dropped.length.toString(), 'Dropped'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Divider(
                  //   color: inactive_accent,
                  //   thickness: 1,
                  //   indent: 8,
                  //   endIndent: 8,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 8.0, vertical: 5.0),
                  //   child: Row(
                  //     children: [
                  //       const Text(
                  //         'Select Movie Language',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       const Spacer(),
                  //       InkWell(
                  //         onTap: () async {
                  //           HapticFeedback.mediumImpact();
                  //           await showLanguage(context);
                  //           langanuageMovie.value =
                  //               await APIService().getMovieLanguage();
                  //         },
                  //         child: SizedBox(
                  //           child: Row(
                  //             children: [
                  //               ValueListenableBuilder(
                  //                 valueListenable: languageNotifier,
                  //                 builder: (context, value, child) {
                  //                   return Text(
                  //                     languageNotifier.value
                  //                         .toString()
                  //                         .split('.')
                  //                         .last,
                  //                     style: const TextStyle(
                  //                       color: Colors.white,
                  //                       fontSize: 18,
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //               const Icon(
                  //                 Icons.arrow_forward_ios_rounded,
                  //                 color: Colors.white,
                  //                 size: 18,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

//   Future<void> showLanguage(BuildContext context) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF12121C).withOpacity(0.95),
//           title: Text(
//             'Select Language',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.5),
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               contentTextTitle(
//                 'English',
//                 () {
//                   languageNotifier.value = LanguageType.English;
//                   // setState(() {
//                   //   movieLan = 'English';
//                   // });
//                 },
//                 languageNotifier.value == LanguageType.English,
//                 context,
//               ),
//               const SizedBox(height: 12),
//               contentTextTitle(
//                 'Hindi',
//                 () {
//                   languageNotifier.value = LanguageType.Hindi;
//                   // setState(() {
//                   //   movieLan = 'Hindi';
//                   // });
//                 },
//                 languageNotifier.value == LanguageType.Hindi,
//                 context,
//               ),
//               const SizedBox(height: 12),
//               contentTextTitle(
//                 'Tamil',
//                 () {
//                   languageNotifier.value = LanguageType.Tamil;
//                   // setState(() {
//                   //   movieLan = 'Tamil';
//                   // });
//                 },
//                 languageNotifier.value == LanguageType.Tamil,
//                 context,
//               ),
//               const SizedBox(height: 12),
//               contentTextTitle('Telugu', () {
//                 languageNotifier.value = LanguageType.Telugu;
//                 // setState(() {
//                 //   movieLan = 'Telugu';
//                 // });
//               }, languageNotifier.value == LanguageType.Telugu, context),
//               const SizedBox(height: 12),
//               contentTextTitle(
//                 'Kannada',
//                 () {
//                   languageNotifier.value = LanguageType.Kannada;
//                   setState(() {
//                     movieLan = 'Kannada';
//                   });
//                 },
//                 languageNotifier.value == LanguageType.Kannada,
//                 context,
//               ),
//               const SizedBox(height: 12),
//               contentTextTitle(
//                 'Malayalam',
//                 () {
//                   languageNotifier.value = LanguageType.Malayalam;
//                   setState(() {
//                     movieLan = 'Malayalam';
//                   });
//                 },
//                 languageNotifier.value == LanguageType.Malayalam,
//                 context,
//               ),
//               const SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

  Widget watchListTile(String count, String title) {
    return Container(
      height: 110,
      width: 160,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF14303B).withOpacity(0.25),
        border: Border.all(
            color: const Color(0xFF14303B).withOpacity(0.5), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              count,
              style: TextStyle(
                color: accent_secondary,
                fontSize: 36,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
