import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:outlands_ans2/view/home_page.dart';

import '../util/constants.dart';
import '../view/staudent_page.dart';
import '../view/teacher_page.dart';

class AppRouter {

  static GoRouter get router => _router;

  static const root = "/";

  static final GoRouter _router = GoRouter(
      initialLocation: root,
      routes: <RouteBase>[
        GoRoute(
          path: root,
          builder: (context, state) => const MyHomePage(),
        ),
        GoRoute(
          path: '$root${Constants.teacher}',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const TeacherPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(CurveTween(curve: Curves.bounceInOut).animate(animation)),
                    child: child,
                  );
                },
              );
            }
        ),
        GoRoute(
          path: '$root${Constants.student}',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const StudentPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(CurveTween(curve: Curves.easeInOut).animate(animation)),
                    child: child,
                  );
                },
              );
            }
        ),
     ],
  );

}