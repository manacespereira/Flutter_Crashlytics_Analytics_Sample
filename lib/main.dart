import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_firebase_sample/anlytics/analytics_page.dart';
import 'package:flutter_firebase_sample/anlytics/tabs_page.dart';
import 'package:flutter_firebase_sample/crashlytics/crash_page.dart';
import 'package:flutter_firebase_sample/dynamic_link/deep_link_page1.dart';
import 'package:flutter_firebase_sample/dynamic_link/deep_link_page2.dart';
import 'package:flutter_firebase_sample/dynamic_link/dynamic_link_generate_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
        DynamicLinkGeneratePage.ROUTE: (context) => DynamicLinkGeneratePage(),
        DeeplinkPage.ROUTE: (context) => DeeplinkPage(),
        DeeplinkPage2.ROUTE: (context) => DeeplinkPage2(),
      },
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('all link $deepLink');
      print('deeplink path ${deepLink.path}');
      Navigator.of(context).pushNamed(deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('all link $deepLink');
        print('deeplink path callback ${deepLink.path}');
        Navigator.of(context).pushNamed(deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Firebase Crashlytics 샘플'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CrashlyticsPage.ROUTE),
            ),
            RaisedButton(
              child: Text('Firebase Analytics 샘플'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AnalyticsPage.ROUTE),
            ),
            RaisedButton(
              child: Text('Firebase Dynamic link 프로그래밍 적으로 딥링크 생성하기'),
              onPressed: () => Navigator.of(context)
                  .pushNamed(DynamicLinkGeneratePage.ROUTE),
            ),
            // RaisedButton(
            //   child: Text('Firebase Dynamic link 바로 딥링크 접근'),
            //   onPressed: () =>launch('https://clientflutter.page.link/muUh'),
            // ),
          ],
        ),
      ),
    );
  }
}
