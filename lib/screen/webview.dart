import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview/widgets/webview_bottom.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/connection.dart';
import 'package:lottie/lottie.dart';

class WebViewExample extends StatefulWidget {
  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  var url = 'https://www.m.biketravelart.com/';
  var currentProgress = 0;
  var init = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void _setProgress(int progess) {
    setState(() {
      currentProgress = progess;
    });
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final _connected = Provider.of<Connection>(context).getConnection;
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        body: SafeArea(
          child: !_connected
              ? Center(
                  child: Lottie.asset(
                    'assets/no_internet.json',
                    width: 250,
                    height: 350,
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: WebView(
                        initialUrl: url,
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageStarted: (url) {
                          print("this is message : " + url);
                        },
                        onPageFinished: (str) {
                          print('this is the end url ' + url);
                        },
                        onProgress: _setProgress,
                        onWebViewCreated: (webViewController) async {
                          // finally signal a complete() to the completer
                          _controller.complete(webViewController);
                        },
                      ),
                    ),
                    Center(
                      child: currentProgress < 100
                          ? Lottie.asset('assets/loading.json')
                          : Container(),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: _connected ? WebViewBottom(_controller) : null,
      ),
    );
  }

  Future<bool> _backPressed() async {
    return true;
  }
}
