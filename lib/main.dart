import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlands_ans2/route/router.dart';

import 'database/db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    _initDb();
    super.initState();
  }

  void _initDb() {
    Future(() => DBHelper.internal().initDb());
  }

  @override
  void dispose() {
    super.dispose();
    DBHelper.internal().close();
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: const MaterialColor(
                0xFF000000,
                <int, Color>{
                  50: Colors.blue,
                  100: Colors.blue,
                  200: Colors.blue,
                  300: Colors.blue,
                  400: Colors.blue,
                  500: Colors.blue,
                  600: Colors.blue,
                  700: Colors.blue,
                  800: Colors.blue,
                  900: Colors.blue,
                },
              ),
              pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                    TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
                  }),
            ),
          ),
        )
    );
  }
}