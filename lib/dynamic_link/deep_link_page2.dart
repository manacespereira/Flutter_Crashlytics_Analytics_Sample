import 'package:flutter/material.dart';

class DeeplinkPage2 extends StatelessWidget {
  static const String ROUTE = '/helloworld2';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrangeAccent,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '딥링크로 들어온 두 번쨰 페이지 입니다',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'HelloWorld222222!',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            )
          ],
        )),
      ),
    );
  }
}
