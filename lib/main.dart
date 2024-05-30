import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hess_app/bloc/authetication/auth_bloc.dart';
import 'package:hess_app/di/di.dart';
import 'package:hess_app/screens/login_screen.dart';
import 'package:hess_app/util/auth_manager.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getItInit();
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AuthBloc(
          locator.get(),
        ),
        child: (AuthManager.readAuth().isEmpty)
            ? BlocProvider(
                create: (context) => AuthBloc(
                  locator.get(),
                ),
                child: LoginScreen(),
              )
            : WebViewApp(),
      ),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({
    super.key,
  });

  // final String title;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late WebViewController controller;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.hesetazegi.ir/fa/'));

    controller.setNavigationDelegate(
      NavigationDelegate(
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
