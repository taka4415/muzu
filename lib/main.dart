import 'package:englishapp/responsive/mobile_screen_layout.dart';
import 'package:englishapp/responsive/responsive_layout_screen.dart';
import 'package:englishapp/responsive/web_screen_layout.dart';
import 'package:englishapp/routes/ItemScreenArg.dart';
import 'package:englishapp/screens/memorize_screen.dart';
import 'package:englishapp/screens/review_screen.dart';
import 'package:englishapp/screens/start_screen.dart';
import 'package:englishapp/screens/video_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('words');
  await Hive.openBox('settings');
  await Hive.openBox('titles');
  await Hive.openBox('title_words');
  await Hive.openBox('myanswer');
  await Hive.openBox<Map>('review');
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAvbk70awvJAf_ZIsaL0W9cBzRdo5nrASE',
          appId: '1:81183211167:ios:9b7510e34cb0e087156caa',
          messagingSenderId: '81183211167',
          storageBucket: 'englishapp-e441f.appspot.com',
          projectId: 'englishapp-e441f'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Muzu',
      theme: ThemeData.light().copyWith(),
      // home: const ResponsiveLayout(
      //   webSreenLayout: WebScreenLayout(),
      //   mobileSreenLayout: MobileScreenLayout(),
      // ),
      routes: {
        '/': (context) => const ResponsiveLayout(
              webSreenLayout: WebScreenLayout(),
              mobileSreenLayout: MobileScreenLayout(),
            ),
        // '/item': (context) => VideoItemScreen(),
        // '/start': (context) => StartScreen(),
        // '/learning': (context) => LearningScreen(),
        // '/result': (context) => ResultScreen(),
      },
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == "/item") {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as ItemScreenArguments;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return VideoItemScreen(
                snap: args.snap,
              );
            },
          );
        }
        if (settings.name == "/start") {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as ItemScreenArguments;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            settings: const RouteSettings(name: "/start"),
            builder: (context) {
              return StartScreen(
                snap: args.snap,
              );
            },
          );
        }
        if (settings.name == "/memorize") {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as ItemScreenArguments;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.

          return MaterialPageRoute(
            settings: const RouteSettings(name: "/memorize"),
            builder: (context) {
              return MemorizeScreen(
                snap: args.snap,
              );
            },
          );
        }

        if (settings.name == "/review") {
          return MaterialPageRoute(
            settings: const RouteSettings(name: "/review"),
            builder: (context) {
              return const ReviewScreen();
            },
          );
        }

        // The code only supports
        // PassArgumentsScreen.routeName right now.
        // Other values need to be implemented if we
        // add them. The assertion here will help remind
        // us of that higher up in the call stack, since
        // this assertion would otherwise fire somewhere
        // in the framework.
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
