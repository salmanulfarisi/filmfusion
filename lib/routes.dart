import 'package:filmfusion/views/downloadscreen.dart';
import 'package:filmfusion/views/loginscreen.dart';
import 'package:filmfusion/views/mainscreen.dart';
import 'package:filmfusion/views/malayalam/latestMovie.dart';
import 'package:filmfusion/views/moviescreen.dart';
import 'package:filmfusion/views/navscreen.dart';
import 'package:filmfusion/views/profilescreen.dart';
import 'package:filmfusion/views/searchscreen.dart';
import 'package:filmfusion/views/tvshowscreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const NavScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
    pageBuilder: defaultPageBuilder<LoginScreen>(const LoginScreen()),
  ),
  GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
      pageBuilder: defaultPageBuilder<MainScreen>(const MainScreen())),
  GoRoute(
    path: '/search',
    builder: (context, state) => const SearchScreen(),
    pageBuilder: defaultPageBuilder<SearchScreen>(const SearchScreen()),
  ),
  GoRoute(
    path: '/download',
    builder: (context, state) => const DownloadScreen(),
    pageBuilder: defaultPageBuilder<DownloadScreen>(const DownloadScreen()),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfileScreen(),
    pageBuilder: defaultPageBuilder<ProfileScreen>(const ProfileScreen()),
  ),
  GoRoute(
    path: '/latestMalayalam',
    builder: (context, state) => LatestMalayalamMovie(),
    pageBuilder:
        defaultPageBuilder<LatestMalayalamMovie>(LatestMalayalamMovie()),
  ),
  GoRoute(
    path: '/movie/:id',
    builder: (context, state) =>
        MovieScreen(movieId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/tv/:id',
    builder: (context, state) => TVShowScreen(state.pathParameters['id']!),
  )
]);

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
        Widget child) =>
    (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
