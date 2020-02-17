import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsPage extends StatefulWidget {
  static const String ROUTE = '/crashlytics';

  @override
  _CrashlyticsPageState createState() => _CrashlyticsPageState();
}

class _CrashlyticsPageState extends State<CrashlyticsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Crashlytics Sample'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
                child: const Text('Key'),
                onPressed: () {
                  Crashlytics.instance.setString('foo', 'bar');
                }),
            FlatButton(
                child: const Text('Log'),
                onPressed: () {
                  Crashlytics.instance.log('baz');
                }),
            FlatButton(
                child: const Text('Crash'),
                onPressed: () {
                  // Use Crashlytics to throw an error. Use this for
                  // confirmation that errors are being correctly reported.
                  Crashlytics.instance.crash();
                }),
            FlatButton(
                child: const Text('Throw Error'),
                onPressed: () {
                  // Example of thrown error, it will be caught and sent to
                  // Crashlytics.
                  throw StateError('Uncaught error thrown by app.');
                }),
            FlatButton(
                child: const Text('Async out of bounds(FlutterError)'),
                onPressed: () {
                  // Example of an exception that does not get caught
                  // by `FlutterError.onError` but is caught by the `onError` handler of
                  // `runZoned`.
                  Future<void>.delayed(const Duration(seconds: 2), () {
                    final List<int> list = <int>[];
                    print(list[100]);
                  });
                }),
            FlatButton(
                child: const Text('Record Error'),
                onPressed: () {
                  try {
                    throw 'error_example';
                  } catch (e, s) {
                    // "context" will append the word "thrown" in the
                    // Crashlytics console.
                    Crashlytics.instance
                        .recordError(e, s, context: 'as an example');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
