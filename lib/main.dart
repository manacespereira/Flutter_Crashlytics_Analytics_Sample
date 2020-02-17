import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_firebase_sample/anlytics/analytics_page.dart';
import 'package:flutter_firebase_sample/anlytics/tabs_page.dart';
import 'package:flutter_firebase_sample/crashlytics/crash_page.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _MyAppState createState() => _MyAppState(analytics, observer);
}

class _MyAppState extends State<MyApp> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _MyAppState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        CrashlyticsPage.ROUTE: (context) => CrashlyticsPage(),
        AnalyticsPage.ROUTE: (context) => AnalyticsPage(
              analytics: analytics,
              observer: observer,
            ),
        TabsPage.ROUTE: (context) => TabsPage(observer),
      },
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Firebase Crashlytics Sample'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CrashlyticsPage.ROUTE),
            ),
            RaisedButton(
              child: Text('Firebase Analytics Sample'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AnalyticsPage.ROUTE),
            )
          ],
        ),
      ),
    );
  }
}
