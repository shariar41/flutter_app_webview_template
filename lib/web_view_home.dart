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
  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var url = "https://google.com";

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {});
  }

  searchURL() {
    setState(() {
      url = "https://www." + controller.text;
      flutterWebviewPlugin.reloadUrl(url);
      controller.text = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check(),
        builder: (context, snapshot) {
          if (hasInternet ||
              snapshot.connectionState != ConnectionState.active) {
            return SafeArea(
              child: Scaffold(
                body: WebviewScaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.green,
                    leading: InkWell(
                      onTap: (){
                        setState(() {
                          flutterWebviewPlugin.reloadUrl(url);
                        });
                      },
                        child: Icon(Icons.refresh)
                    ),
                    title: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (url) => searchURL(),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search Here",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            flutterWebviewPlugin.goBack();
                            controller.text = "";
                          }),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: searchURL,
                      ),
                    ],
                  ),
                  url: "https://www.google.com",
                  withZoom: true,
                  withLocalStorage: true,
                  appCacheEnabled: true,
                  // hidden: true,
                  withLocalUrl: true,
                  withJavascript: true,
                  scrollBar: true,
                  initialChild: Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Container(
                color: Colors.white,
                //padding: const EdgeInsets.only(top: 50),
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
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
