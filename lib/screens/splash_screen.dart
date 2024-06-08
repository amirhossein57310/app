import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:hess_app/bloc/authetication/auth_bloc.dart';
import 'package:hess_app/di/di.dart';
import 'package:hess_app/screens/login_screen.dart';

import 'package:hess_app/util/auth_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool click = false;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1300), () {
      if (AuthManager.readAuth().isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return BlocProvider(
              create: (context) => AuthBloc(
                locator.get(),
              ),
              child: LoginScreen(),
            );
          }),
        );
      }
      // else {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => WebViewScreen()),
      //   );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 240),
            child: SvgPicture.asset(
              height: 150,
              width: 150,
              'assets/images/logo.svg',
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Text(
              'version 17.3.5',
              style: TextStyle(
                  fontFamily: 'BKM', fontSize: 12, color: Color(0xff666666)),
            ),
          ),
        ],
      ),
    );
  }
}
