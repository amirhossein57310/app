import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:hess_app/bloc/authetication/auth_bloc.dart';
import 'package:hess_app/bloc/authetication/auth_event.dart';
import 'package:hess_app/di/di.dart';
import 'package:hess_app/main.dart';
import 'package:hess_app/util/auth_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  FocusNode listener = FocusNode();
  bool isTapped = false;
  bool isTapped2 = false;
  String hintText = 'شماره موبایل یا ایمیل';
  bool showHintText = true;
  String? _errorMessage;

  Timer? _timer;
  int _start =
      90; // Initial countdown value (in seconds, e.g., 1:30 is 90 seconds)
  // bool _isButtonDisabled = false;

  bool isPersianPhone(String input) {
    // Persian mobile numbers (e.g., 09123456789)
    final mobileRegExp = RegExp(r'^(\+98|0)?9\d{9}$');

    // Persian landline numbers (e.g., 02112345678)
    final landlineRegExp = RegExp(r'^(\+98|0)?2[1-9]\d{8}$');

    return mobileRegExp.hasMatch(input) || landlineRegExp.hasMatch(input);
  }

  bool isEmail(String input) => EmailValidator.validate(input);

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorMessage = 'شماره موبایل یا ایمیل خود را وارد کنید';
      } else if (!isEmail(value) && !isPersianPhone(value)) {
        _errorMessage = 'شماره موبایل یا ایمیل خود را بررسی کنید';
      } else {
        _errorMessage = null;
      }
    });
  }

  void startTimer() {
    setState(() {
      //  _isButtonDisabled = true;
      _start = 5; // Reset to 1:30 (90 seconds)
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          //   _isButtonDisabled = false;
        });
        _timer?.cancel();
      } else {
        setState(() {
          --_start;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xffF5F5F5),
        leading: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Image.asset(
            'assets/images/question.png',
          ),
        ),
        centerTitle: true,
        title: Text('ورود یا ثبت نام'),
        actions: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Image.asset(
              'assets/images/go.png',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Column(
                children: [
                  Container(
                    height: screenHeight * 0.24,
                  ),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.7,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image4.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        SvgPicture.asset(
                          'assets/images/image3.svg',
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.03),
                          child: isTapped
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(controller.text),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isTapped2 = false;
                                            isTapped = false;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/pen.svg',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text('خوش آمدید'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.03,
                            bottom: screenHeight * 0.03,
                          ),
                          child: isTapped
                              ? Text('لطفا کد پیامکی ارسال شده را وارد کنید')
                              : Text(
                                  ' لطفا شماره موبایل یا ایمیل خود را وارد کنید'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: isTapped2
                                ? TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: controller2,
                                    maxLines: 1,
                                    focusNode: listener,
                                    textAlign: TextAlign.center,
                                    showCursor: false,
                                    onChanged: (_) {
                                      setState(() {
                                        // if (controller2.text.isEmpty) {
                                        //   isTapped2 = false;
                                        // }
                                        //  errorMessage = null;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: '-    -    -    -',
                                      alignLabelWithHint: true,
                                      labelStyle: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color: listener.hasFocus
                                            ? const Color(0xff2E8530)
                                            : const Color(0xffC5C5C5),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color: Color(0xffC5C5C5),
                                            width: 1.0),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xff2E8530)),
                                      ),
                                      // errorText: errorMessage,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  )
                                : Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      controller: controller,
                                      maxLines: 1,
                                      focusNode: listener,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          if (controller.text.isEmpty) {
                                            isTapped = false;
                                          }
                                        });
                                        _validateInput(value);
                                      },
                                      autovalidateMode: AutovalidateMode.always,
                                      decoration: InputDecoration(
                                        hintText: 'شماره موبایل یا ایمیل',
                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          color: listener.hasFocus
                                              ? const Color(0xff2E8530)
                                              : const Color(0xffC5C5C5),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              color: Color(0xffC5C5C5),
                                              width: 1.0),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xff2E8530)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        errorText: _errorMessage,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        isTapped
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: screenHeight * 0.02),
                                child: SizedBox(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.07,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        backgroundColor: Color(0xff2E8530),
                                      ),
                                      onPressed: () {
                                        //  print(AuthManager.readActionCode());
                                        //  _showModalSheet(context);

                                        // if (controller.text.isNotEmpty) {
                                        //   setState(() {
                                        //     isTapped = true;
                                        //     isTapped2 = true;
                                        //   });
                                        //   _timer?.cancel();
                                        //   startTimer(); // Start the countdown timer when button is pressed
                                        // }
                                        if (AuthManager.readActionCode() == 0 ||
                                            AuthManager.readActionCode() == 1) {
                                          _showModalSheet(context);
                                        } else {
                                          WebViewApp();
                                        }
                                      },
                                      child: Text(
                                        'تایید',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      )),
                                ),
                              )
                            : Padding(
                                padding:
                                    EdgeInsets.only(top: screenHeight * 0.02),
                                child: SizedBox(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.07,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: Color(0xff2E8530),
                                    ),
                                    onPressed: () {
                                      if (controller.text.isNotEmpty) {
                                        setState(() {
                                          isTapped = true;
                                          isTapped2 = true;
                                        });
                                        _timer?.cancel();
                                        startTimer(); // Start the countdown timer when button is pressed
                                      }
                                      BlocProvider.of<AuthBloc>(context).add(
                                        AuthLoginRequest(
                                            controller.text, controller.text),
                                      );
                                    },
                                    child: Text(
                                      'ورود یا ثبت نام',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        isTapped
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 4),
                                    _start != 0
                                        ? Text(
                                            'ارسال مجدد کد $formattedTime',
                                            style: TextStyle(
                                                color: Color(0xff666666)),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              _timer?.cancel();
                                              startTimer();
                                            },
                                            child: Text(
                                              'ارسال مجدد کد پیامکی',
                                              style: TextStyle(
                                                color: Color(0xff2E8530),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            : Text(''),
                        SizedBox(
                          height: screenHeight * 0.32,
                        ), // Placeholder for timer text
                        Text(
                          'version 17.3.5',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0), // Adjust the radius as needed
        ),
      ),
      backgroundColor: Color(0xffF5F5F5),
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Container(
            height: 354,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Container(
                    width: 64,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/cancle.svg',
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('ثبت نام'),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                          'لطفا اطلاعات زیر را جهت تکمیل ثبت نام خود کامل کنید'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: SizedBox(
                        width: 328,
                        height: 48,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: controller3,
                            decoration: InputDecoration(
                              hintText: 'نام',
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 328,
                      height: 48,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: controller4,
                          decoration: InputDecoration(
                            hintText: 'نام خانوادگی',
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 328,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Color(0xff2E8530),
                          ),
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              AuthVerifingRequest(
                                controller.text,
                                controller.text,
                                controller3.text,
                                controller4.text,
                                controller2.text.toString(),
                              ),
                            );
                            // if (controller.text.isNotEmpty) {
                            //   setState(() {
                            //     isTapped = true;
                            //     isTapped2 = true;
                            //   });
                            //   _timer?.cancel();
                            //   startTimer(); // Start the countdown timer when button is pressed
                            // }
                          },
                          child: Text(
                            'ثبت نام و ورود',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectItem(BuildContext context, String item) {
    Navigator.pop(context); // Close the modal sheet
    // Perform actions based on selected item
    print('Selected item: $item');
  }
}
