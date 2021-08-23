import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/bottom_sheet.dart';

//ignore: must_be_immutable
class WebViewBottom extends StatefulWidget {
  Completer<WebViewController> _webviewFuture;
  final bool isOpen;
  WebViewBottom(this._webviewFuture, [this.isOpen = false]);
  @override
  _WebViewBottomState createState() => _WebViewBottomState();
}
class _WebViewBottomState extends State<WebViewBottom> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: widget._webviewFuture.future,
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.done
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_back_ios), label: 'Previous'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_forward_ios), label: 'Forward'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.refresh), label: 'Refresh'),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
              ],
              onTap: (index) async {

                if (index == 0) {
                  setState(() {
                    _currentIndex = index;
                  });
                  await snapshot.data!.goBack();
                } else if (index == 1) {
                  setState(() {
                    _currentIndex = index;
                  });
                  await snapshot.data!.goForward();
                } else if (index == 2) {
                  setState(() {
                    _currentIndex = index;
                  });
                  await snapshot.data!.reload();
                } else {
                  if (!widget.isOpen) {
                    setState(() {
                      _currentIndex = index;
                    });
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return  Wrap(
                              children: <Widget>[
                                Container(
                                    child: BottomView(widget._webviewFuture),
                                )
                              ]
                          );
                        });
                  }
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
            )
          : Container(),
    );
  }
}
