import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hess_app/bloc/authetication/auth_bloc.dart';
import 'package:hess_app/di/di.dart';
import 'package:hess_app/screens/login_screen.dart';
import 'package:hess_app/screens/splash_screen.dart';
import 'package:hess_app/screens/verify_scree.dart';
import 'package:hess_app/screens/web_view_screen.dart';
import 'package:hess_app/util/auth_manager.dart';

import 'package:flutter/services.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FlutterNativeSplash.remove();

  await getItInit();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(
        locator.get(),
      ),
      child: MyApp(),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   initialize();
  // }

  // void initialize() async {
  //   await Future.delayed(Duration(seconds: 3));
  // }

  @override
  Widget build(BuildContext context) {
    // AuthManager.logout();
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
              headlineLarge: const TextStyle(
                  fontSize: 21,
                  fontFamily: 'BKO',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000)),
              bodySmall: TextStyle(
                fontSize: 14,
                fontFamily: 'BKL',
                fontWeight: FontWeight.w400,
                color: Color(0xff000000),
              ),
              labelMedium: const TextStyle(
                color: Color(0xffE60023),
                fontSize: 15,
                fontFamily: 'dana',
                fontWeight: FontWeight.bold,
              ))),
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:
          // SplashScreen()
          (AuthManager.readAuth().isEmpty)
              ? BlocProvider(
                  create: (context) => AuthBloc(
                    locator.get(),
                  ),
                  child: LoginScreen(),
                )
              : WebViewScreen(),
    );
  }
}

// class WebViewApp extends StatefulWidget {
//   const WebViewApp({
//     super.key,
//   });

//   // final String title;

//   @override
//   State<WebViewApp> createState() => _WebViewAppState();
// }

// class _WebViewAppState extends State<WebViewApp> {
//   late WebViewController controller;
//   bool canGoBack = false;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse('https://www.hesetazegi.ir/fa/'));

//     controller.setNavigationDelegate(
//       NavigationDelegate(
//         onPageFinished: (String url) async {
//           bool canGoBack = await controller.canGoBack();
//           setState(() {
//             this.canGoBack = canGoBack;
//           });
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (canGoBack) {
//           controller.goBack();
//           return false; // Prevents the app from closing
//         }
//         return true; // Allows the app to close
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: WebViewWidget(
//             controller: controller,
//           ),
//         ),
//       ),
//     );
//   }
// }
