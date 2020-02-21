import 'package:flutter/material.dart';

class DeeplinkPage extends StatelessWidget {
  static const String ROUTE = '/helloworld';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '딥링크로 들어온 첫 번째페이지 입니다.',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'HelloWorld!',
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
