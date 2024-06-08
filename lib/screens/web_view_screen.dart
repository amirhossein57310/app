import 'package:flutter/material.dart';
import 'package:hess_app/util/auth_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
  });

  // final String title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          //Uri.parse('http://192.168.2.112:3000/fa?${AuthManager.readAuth()}'));
          Uri.parse(
              'https://www.hesetazegi.ir/fa/?auth-token=${AuthManager.readAuth()}'));

    controller.setNavigationDelegate(
      NavigationDelegate(
        // onUrlChange: (change) => {
        //   if (change.url == 'https://www.hesetazegi.ir/fa/logout')
        //     {
        //       AuthManager.logout(),
        //     }
        // },
        onPageFinished: (String url) async {
          bool canGoBack = await controller.canGoBack();
          setState(() {
            this.canGoBack = canGoBack;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (canGoBack) {
          controller.goBack();
          return false; // Prevents the app from closing
        }
        return true; // Allows the app to close
      },
      child: Scaffold(
        body: SafeArea(
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
