import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewHomeScreen extends StatefulWidget {
  const WebViewHomeScreen({Key? key}) : super(key: key);

  @override
  _WebViewHomeScreenState createState() => _WebViewHomeScreenState();
}

class _WebViewHomeScreenState extends State<WebViewHomeScreen> {
  bool hasInternet = false, isChecking = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SafeArea(
                child: Scaffold(
                  body: WebviewScaffold(
                    url: "https://www.google.com",
                    withZoom: true,
                    withLocalStorage: true,
                    // hidden: true,
                    withJavascript: true,
                    scrollBar: false,
                    initialChild: Container(
                      color: Colors.white,
                      child: const Center(
                        child:CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            default:{
              return Center(
                child: Container(
                  color: Colors.white,
                  //padding: const EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
        }
    );
  }
  check() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      print("******* Mobile is ON ******");
      setState(() {
        isChecking = false;
        hasInternet = true;
        //navigate to another screen.....
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("******* Wifi is ON ******");
      setState(() {
        isChecking = false;
        hasInternet = true;
        //navigate to another screen.....
      });
    } else {
      setState(() {
        isChecking = false;
        hasInternet = false;
      });
    }
  }
}
