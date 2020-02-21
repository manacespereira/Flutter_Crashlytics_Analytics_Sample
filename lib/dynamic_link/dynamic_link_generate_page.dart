import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLinkGeneratePage extends StatefulWidget {
  static const String ROUTE = '/dynamiclink_generate';

  @override
  _DynamicLinkGeneratePageState createState() =>
      _DynamicLinkGeneratePageState();
}

class _DynamicLinkGeneratePageState extends State<DynamicLinkGeneratePage> {
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      "To test: long press link and then copy and click from a non-browser "
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      "is properly setup. Look at firebase_dynamic_links/README.md for more "
      "details.";

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://clientflutter.page.link',
      link: Uri.parse('https://clientflutter.page.link/helloworld2'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.flutter_firebase_sample',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.flutterFirebaseSample',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Links Example'),
      ),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: !_isCreatingLink
                        ? () => _createDynamicLink(false)
                        : null,
                    child: const Text('긴 딥링크 생성하기'),
                  ),
                  RaisedButton(
                    onPressed: !_isCreatingLink
                        ? () => _createDynamicLink(true)
                        : null,
                    child: const Text('짧은 딥링크 생성하기'),
                  ),
                ],
              ),
              InkWell(
                child: Text(
                  _linkMessage ?? '',
                  style: const TextStyle(color: Colors.blue),
                ),
                onTap: () async {
                  if (_linkMessage != null) {
                    await launch(_linkMessage);
                  }
                },
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: _linkMessage));
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text('복사했습니당')),
                  );
                },
              ),
              Text(_linkMessage == null ? '' : _testString)
            ],
          ),
        );
      }),
    );
  }
}
