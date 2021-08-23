import 'package:flutter/material.dart';
import 'package:flutter_webview/providers/connection.dart';
import 'package:provider/provider.dart';
import './screen/splash_screen.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Connection(),
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
void getHttp() async {
  try {
    var response = await Dio().get('https://www.m.biketravelart.com');
    print(response);
  } catch (e) {
    print(e);
  }
}