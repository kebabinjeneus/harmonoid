import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harmonoid/language/language.dart';
import 'package:harmonoid/scripts/discover.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:audio_service/audio_service.dart';

import 'package:harmonoid/screens/home.dart';
import 'package:harmonoid/scripts/collection.dart';
import 'package:harmonoid/scripts/fileintent.dart';
import 'package:harmonoid/scripts/configuration.dart';
import 'package:harmonoid/scripts/playback.dart';
import 'package:harmonoid/screens/nowplaying.dart';
import 'package:harmonoid/screens/exception.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  try {
    await Configuration.init(
      cacheDirectory: await path.getExternalStorageDirectory(),
    );
    await Collection.init(
      collectionDirectory: Directory('/storage/emulated/0/Music'),
      cacheDirectory: await path.getExternalStorageDirectory(),
    );
    await Discover.init(
      homeAddress: configuration.homeAddress,
    );
    await Language.init(
      languageRegion: configuration.languageRegion,
    );
    await FileIntent.init();
    runApp(
      new AudioServiceWidget(
        child: new Harmonoid(),
      ),
    );
  }
  catch(exception) {
    runApp(
      new ExceptionMaterialApp(
        exception: exception,
      ),
    );
  }
}


void backgroundTaskEntryPoint() {
  AudioServiceBackground.run(() => BackgroundTask());
}


class Harmonoid extends StatefulWidget {
  Harmonoid({Key key}) : super(key: key);
  HarmonoidState createState() => HarmonoidState();
}


class HarmonoidState extends State<Harmonoid> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'harmonoid',
      theme: new ThemeData(
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        brightness: Brightness.light,
        primaryColorLight: Colors.deepPurpleAccent,
        primaryColor: Colors.deepPurpleAccent[400],
        primaryColorDark: Colors.deepPurpleAccent[700],
        scaffoldBackgroundColor: Colors.grey[100],
        cursorColor: Colors.deepPurpleAccent[700],
        accentColor: Colors.deepPurpleAccent[400],
        textSelectionHandleColor: Colors.deepPurpleAccent[400],
        toggleableActiveColor: Colors.deepPurpleAccent[400],
        cardColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent[100],
        dividerColor: Colors.black12,
        disabledColor: Colors.black38,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.deepPurpleAccent[700],
          unselectedLabelColor: Colors.black54,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.light,
          elevation: 4.0,
          iconTheme: IconThemeData(
            color: Colors.black54,
            size: 24,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black54,
            size: 24,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black54,
          size: 24,
        ),
        bottomNavigationBarTheme: new BottomNavigationBarThemeData(
          backgroundColor: Colors.deepPurpleAccent[700],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
        ),
        primaryTextTheme: new TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 18,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 16,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black54,
            fontSize: 16,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 14,
          ),
          headline5: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black54,
            fontSize: 14,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        textTheme: new TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 18,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 16,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black54,
            fontSize: 16,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 14,
          ),
          headline5: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black54,
            fontSize: 14,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
      ),
      darkTheme: new ThemeData(
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColorLight: Colors.deepPurpleAccent[100],
        primaryColor: Colors.deepPurpleAccent[100],
        primaryColorDark: Colors.deepPurpleAccent[100],
        scaffoldBackgroundColor: Color(0xFF121212),
        cursorColor: Colors.deepPurpleAccent[100],
        accentColor: Colors.deepPurpleAccent[100],
        textSelectionHandleColor: Colors.deepPurpleAccent[100],
        toggleableActiveColor: Colors.deepPurpleAccent[100],
        cardColor: Colors.white.withOpacity(0.14),
        backgroundColor: Colors.deepPurple[100],
        dividerColor: Colors.white12,
        disabledColor: Colors.white38,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.deepPurpleAccent[100],
          unselectedLabelColor: Colors.white.withOpacity(0.54),
        ),
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(42, 42, 42, 1),
          brightness: Brightness.dark,
          elevation: 4.0,
          iconTheme: IconThemeData(
            color: Colors.black54,
            size: 24,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black54,
            size: 24,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.54),
          size: 24,
        ),
        bottomNavigationBarTheme: new BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(42, 42, 42, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
        ),
        primaryTextTheme: new TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 18,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 16,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.54),
            fontSize: 16,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 14,
          ),
          headline5: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.54),
            fontSize: 14,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 18,
          ),
        ),
        textTheme: new TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 18,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 16,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.54),
            fontSize: 16,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 14,
          ),
          headline5: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.54),
            fontSize: 14,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.87),
            fontSize: 18,
          ),
        ),
      ),
      themeMode: configuration.themeMode,
      home: Home(),
      onGenerateRoute: (RouteSettings routeSettings) {
        PageRoute route;
        if (routeSettings.name == 'nowPlaying') {
          route = new PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 400),
            reverseTransitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            pageBuilder: (context, animation, secondaryAnimation) => NowPlaying(),
          );
        }
        return route;
      },
    );
  }
}

final FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();
final InitializationSettings notificationSettings = InitializationSettings(
  android: AndroidInitializationSettings('mipmap/ic_launcher'),
);
