import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:hess_app/bloc/authetication/auth_bloc.dart';
import 'package:hess_app/bloc/authetication/auth_event.dart';
import 'package:hess_app/bloc/authetication/auth_state.dart';

import 'package:hess_app/screens/web_view_screen.dart';
import 'package:hess_app/util/auth_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileController = TextEditingController();

  TextEditingController codeController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  FocusNode listener = FocusNode();
  FocusNode firstNameListener = FocusNode();
  FocusNode lastNameListener = FocusNode();

  bool isTapped = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  String hintText = 'شماره موبایل یا ایمیل';
  bool showHintText = true;
  String? _errorMessage;
  //String? _errorMessage2 = '';
  String? value2;
  bool isLongPressed = false;
  bool errorName = false;
  bool errorLastName = false;
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
      if (!isEmail(value) && !isPersianPhone(value)) {
        _errorMessage = 'شماره موبایل یا ایمیل خود را بررسی کنید';
      }
      // if (value.isEmpty) {
      //   _errorMessage = 'شماره موبایل یا ایمیل خود را وارد کنید';
      // } else if (!isEmail(value) && !isPersianPhone(value)) {
      //   _errorMessage = 'شماره موبایل یا ایمیل خود را بررسی کنید';
      // }
      else {
        _errorMessage = null;
      }
    });
  }

  String? _nameErrorMassage = '';
  String? _lastNameErrorMassage = '';

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

  String formatCode(String input) {
    input = input.replaceAll(' ', ''); // Remove any existing spaces
    String formatted = '';
    for (int i = 0; i < input.length; i++) {
      formatted += input[i];
      if (i < input.length - 1) {
        formatted += ' ';
      }
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String? mobile = mobileController.text;
    String? email = mobileController.text;
    String code = codeController.text;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthResponseState) {
          state.response.fold(
            (l) {
              // Handle failure
              Text(l);
            },
            (r) {
              if (AuthManager.readAuth().isNotEmpty) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(),
                  ),
                );
              }
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          resizeToAvoidBottomInset: false,
          appBar: isTapped
              ? AppBar(
                  elevation: 0,
                  forceMaterialTransparency: true,
                  toolbarHeight: 48,
                  backgroundColor: Color(0xffF5F5F5),
                  centerTitle: true,
                  actions: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              width: 24,
                              height: 24,
                              'assets/images/question.svg',
                            ),
                            Text(
                              'ورود یا ثبت نام',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'BKR',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isTapped = false;
                                  isTapped2 = false;
                                });
                              },
                              child: SvgPicture.asset(
                                width: 24,
                                height: 24,
                                'assets/images/back.svg',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Column(
                    children: [
                      Container(
                        height: isTapped
                            ? screenHeight * 0.10
                            : screenHeight * 0.24,
                      ),
                      Container(
                        width: double.infinity,
                        height: isTapped
                            ? screenHeight * 0.83
                            : screenHeight * 0.80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bas.png'),
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
                              height: isTapped
                                  ? screenHeight * 0.08
                                  : screenHeight * 0.13,
                              width: screenWidth * 0.01,
                            ),
                            SvgPicture.asset(
                              'assets/images/image3.svg',
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                              ),
                              child: isTapped
                                  ? Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          isTapped2 = false;
                                          isTapped = false;
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            isLongPressed = true;
                                          });
                                        },
                                        onLongPressEnd: (details) {
                                          setState(() {
                                            isLongPressed = false;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              mobileController.text,
                                              style: TextStyle(
                                                fontFamily: 'BKM',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: isLongPressed
                                                    ? Color(0xff2E8530)
                                                    : Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     setState(() {
                                            //       isTapped2 = false;
                                            //       isTapped = false;
                                            //     });
                                            //   },
                                            //   child:
                                            SvgPicture.asset(
                                              'assets/images/pen.svg',
                                              color: isLongPressed
                                                  ? Color(0xff2E8530)
                                                  : Colors.black,
                                              //  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                      ),
                                      child: Text(
                                        'خوش آمدید',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenHeight * 0.03,
                                bottom: screenHeight * 0.03,
                              ),
                              child: isTapped
                                  ? Text(
                                      'لطفا کد پیامکی ارسال شده را وارد کنید',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  : Text(
                                      ' لطفا شماره موبایل یا ایمیل خود را وارد کنید',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: isTapped2
                                        ? TextFormField(
                                            //  validator: (value) => _validateInput2(value),
                                            keyboardType: TextInputType.number,
                                            controller: codeController,
                                            maxLines: 1,
                                            focusNode: listener,
                                            textAlign: TextAlign.center,
                                            showCursor: false,
                                            // onChanged: (value) {
                                            //   if (value
                                            //           .replaceAll(' ', '')
                                            //           .length <=
                                            //       4) {
                                            //     setState(() {
                                            //       code = codeController.text;
                                            //       code = value;
                                            //       codeController.text =
                                            //           formatCode(code);
                                            //       codeController.selection =
                                            //           TextSelection
                                            //               .fromPosition(
                                            //         TextPosition(
                                            //             offset: codeController
                                            //                 .text.length),
                                            //       );
                                            //     });
                                            //   } else {
                                            //     setState(() {
                                            //       codeController.text =
                                            //           formatCode(code);
                                            //       codeController.selection =
                                            //           TextSelection
                                            //               .fromPosition(
                                            //         TextPosition(
                                            //             offset: codeController
                                            //                 .text.length),
                                            //       );
                                            //     });
                                            //   }
                                            // },
                                            // inputFormatters: [
                                            //   FilteringTextInputFormatter
                                            //       .digitsOnly,
                                            // ],
                                            onChanged: (value) {
                                              if (value.length > 4) {
                                                codeController.text =
                                                    value.substring(0, 4);
                                                codeController.selection =
                                                    TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: codeController
                                                          .text.length),
                                                );
                                              }
                                              setState(() {
                                                code = codeController.text;
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
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                borderSide: BorderSide(
                                                    color: Color(0xffC5C5C5),
                                                    width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: isTapped3
                                                      ? Color(0xffB3261E)
                                                      : Color(0xff2E8530),
                                                ),
                                              ),
                                              // errorText: errorMessage,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                            ),
                                          )
                                        : SizedBox(
                                            width: 328,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                style: TextStyle(
                                                  fontFamily: 'BKM',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                controller: mobileController,
                                                maxLines: 1,
                                                focusNode: listener,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                  setState(() {
                                                    mobile =
                                                        mobileController.text;
                                                    email =
                                                        mobileController.text;
                                                    if (mobileController
                                                        .text.isEmpty) {
                                                      isTapped = false;
                                                    }
                                                  });

                                                  _validateInput(value);
                                                },
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'شماره موبایل یا ایمیل',
                                                  hintStyle: Theme.of(context)
                                                      .copyWith(
                                                          hintColor:
                                                              Color(0xff9E9E9E))
                                                      .textTheme
                                                      .bodySmall,
                                                  alignLabelWithHint: true,
                                                  labelStyle: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.05,
                                                    color: listener.hasFocus
                                                        ? const Color(
                                                            0xff2E8530)
                                                        : const Color(
                                                            0xffC5C5C5),
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xffC5C5C5),
                                                        width: 1.0),
                                                  ),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xff2E8530)),
                                                  ),
                                                  errorBorder:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 1.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 1.0),
                                                  ),
                                                  errorText: mobileController
                                                          .text.isNotEmpty
                                                      ? _errorMessage
                                                      : value2,
                                                  errorStyle: TextStyle(
                                                    fontFamily: 'BKM',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffB3261E),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  // isTapped3
                                  //     ? Padding(
                                  //         padding: const EdgeInsets.only(
                                  //           right: 20,
                                  //           top: 3,
                                  //         ),
                                  //         child: Text(
                                  //           'کد پیامکی ارسال شده را مجدد وارد کنید',
                                  //           style: TextStyle(
                                  //             color: Color(0xffB3261E),
                                  //             fontFamily: 'BKR',
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w400,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Text('')
                                ],
                              ),
                            ),
                            isTapped
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.02),
                                    child: SizedBox(
                                        width: screenWidth * 0.9,
                                        height: 48,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            backgroundColor: Color(0xff2E8530),
                                          ),
                                          onPressed: () {
                                            if (AuthManager.readActionCode() ==
                                                    0 ||
                                                AuthManager.readActionCode() ==
                                                    1) {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16.0),
                                                    topRight:
                                                        Radius.circular(16.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Color(0xffF5F5F5),
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child: BlocListener<
                                                            AuthBloc,
                                                            AuthState>(
                                                          listener:
                                                              (context, state) {
                                                            if (state
                                                                is AuthResponseState) {
                                                              state.response
                                                                  .fold(
                                                                (failure) {
                                                                  // Handle failure
                                                                  Text(failure);
                                                                },
                                                                (success) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacement(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              WebViewScreen(),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      16.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      16.0),
                                                            ),
                                                            child: Container(
                                                              height: 365,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                      width: double
                                                                          .infinity),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      width: 64,
                                                                      height: 4,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xffE0E0E0),
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                              'assets/images/cancle.svg'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'ثبت نام',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xff000000),
                                                                          fontFamily:
                                                                              'BKB',
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          'لطفا اطلاعات زیر را جهت تکمیل ثبت نام خود وارد کنید',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff4D4D4D),
                                                                            fontFamily:
                                                                                'BKR',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              328,
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.11,
                                                                          child:
                                                                              Directionality(
                                                                            textDirection:
                                                                                TextDirection.rtl,
                                                                            child:
                                                                                TextField(
                                                                              controller: firstnameController,
                                                                              focusNode: firstNameListener,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'نام',
                                                                                hintStyle: TextStyle(
                                                                                  color: Color(0xff666666),
                                                                                  fontFamily: 'BKR',
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                                enabledBorder: const OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                                                ),
                                                                                focusedBorder: const OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  borderSide: BorderSide(width: 1, color: Colors.green),
                                                                                ),
                                                                                errorBorder: const OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                                                                                ),
                                                                                focusedErrorBorder: const OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                                                                                ),
                                                                                errorText: errorName ? _nameErrorMassage : null,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            328,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.11,
                                                                        child:
                                                                            Directionality(
                                                                          textDirection:
                                                                              TextDirection.rtl,
                                                                          child:
                                                                              TextField(
                                                                            controller:
                                                                                lastnameController,
                                                                            focusNode:
                                                                                lastNameListener,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: 'نام خانوادگی',
                                                                              hintStyle: TextStyle(
                                                                                color: Color(0xff666666),
                                                                                fontFamily: 'BKR',
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                              enabledBorder: const OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                                              ),
                                                                              focusedBorder: const OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                borderSide: BorderSide(width: 1, color: Colors.green),
                                                                              ),
                                                                              errorBorder: const OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                                                                              ),
                                                                              focusedErrorBorder: const OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                                                                              ),
                                                                              errorText: errorLastName ? _lastNameErrorMassage : null,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                40),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              328,
                                                                          height:
                                                                              48,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              elevation: 0,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(16),
                                                                              ),
                                                                              backgroundColor: Color(0xff2E8530),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                bool isValid = true;
                                                                                if (firstnameController.text.isEmpty) {
                                                                                  errorName = true;
                                                                                  _nameErrorMassage = 'نام خود را وارد کنید';
                                                                                  isValid = false;
                                                                                } else {
                                                                                  errorName = false;
                                                                                }
                                                                                if (lastnameController.text.isEmpty) {
                                                                                  errorLastName = true;
                                                                                  _lastNameErrorMassage = 'نام خانوادگی خود را وارد کنید';
                                                                                  isValid = false;
                                                                                } else {
                                                                                  errorLastName = false;
                                                                                }

                                                                                if (isValid) {
                                                                                  BlocProvider.of<AuthBloc>(context).add(
                                                                                    AuthVerifingRequest(
                                                                                      mobile,
                                                                                      email,
                                                                                      firstnameController.text,
                                                                                      lastnameController.text,
                                                                                      code.toString(),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'ثبت نام و ورود',
                                                                              style: TextStyle(
                                                                                fontFamily: 'BKR',
                                                                                color: Color(0xffFFFFFF),
                                                                                fontSize: 16,
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
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            } else {
                                              if (AuthManager.readActionCode() != 0 &&
                                                  AuthManager
                                                          .readActionCode() !=
                                                      1 &&
                                                  code.isNotEmpty) {
                                                BlocProvider.of<AuthBloc>(
                                                        context)
                                                    .add(
                                                        AuthSecondVerifingRequest(
                                                            mobileController
                                                                .text,
                                                            mobileController
                                                                .text,
                                                            firstnameController
                                                                .text,
                                                            lastnameController
                                                                .text,
                                                            code));
                                                // Navigator.of(context)
                                                //     .pushReplacement(
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         WebViewScreen(),
                                                //   ),
                                                // );
                                              }
                                            }
                                          },
                                          child: Text(
                                            'تایید',
                                            style: TextStyle(
                                              fontFamily: 'BKR',
                                              color: Color(0xffFFFFFF),
                                              fontSize: 14,
                                            ),
                                          ),
                                        )),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      // top: screenHeight * 0.0001
                                      top: 16,
                                    ),
                                    child: SizedBox(
                                      width: 328,
                                      height: 48,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          backgroundColor: Color(0xff2E8530),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            value2 =
                                                'ایمیل یا موبایل خود را وارد نمایید';
                                          });
                                          if (mobileController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              isTapped = true;
                                              isTapped2 = true;
                                            });
                                            _timer?.cancel();
                                            startTimer();
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(
                                              AuthLoginRequest(
                                                  mobileController.text,
                                                  mobileController.text),
                                            );
                                          }
                                        },
                                        child: Text(
                                          'ورود یا ثبت نام',
                                          style: TextStyle(
                                            fontFamily: 'BKR',
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 4),
                                        _start != 0
                                            ? Text(
                                                'ارسال مجدد کد $formattedTime',
                                                style: TextStyle(
                                                    fontFamily: 'BKR',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff666666)),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  _timer?.cancel();
                                                  startTimer();
                                                  BlocProvider.of<AuthBloc>(
                                                          context)
                                                      .add(AuthLoginRequest(
                                                          mobile, email));
                                                  setState(() {
                                                    isTapped3 = true;
                                                  });
                                                },
                                                child: Text(
                                                  'ارسال مجدد کد پیامکی',
                                                  style: TextStyle(
                                                      fontFamily: 'BKR',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff2E8530)),
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                : Text(''),
                            isTapped
                                ? SizedBox(
                                    height: screenHeight * 0.32,
                                  )
                                : SizedBox(
                                    height: screenHeight * 0.36,
                                  ),
                            Text(
                              'version 17.3.5',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'BKR',
                                color: Color(0xffFFFFFF),
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
      },
    );
  }

  // void _showModalSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(16.0),
  //         topRight: Radius.circular(16.0), // Adjust the radius as needed
  //       ),
  //     ),
  //     backgroundColor: Color(0xffF5F5F5),
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ClipRRect(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(16.0),
  //           topRight: Radius.circular(16.0),
  //         ),
  //         child: Container(
  //           height: 354,
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 width: double.infinity,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                   top: 10,
  //                 ),
  //                 child: Container(
  //                   width: 64,
  //                   height: 4,
  //                   decoration: BoxDecoration(
  //                     color: Color(0xffE0E0E0),
  //                     borderRadius: BorderRadius.circular(100),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                   left: 10,
  //                 ),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SvgPicture.asset(
  //                         'assets/images/cancle.svg',
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text('ثبت نام'),
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                       top: 10,
  //                     ),
  //                     child: Text(
  //                         'لطفا اطلاعات زیر را جهت تکمیل ثبت نام خود کامل کنید'),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                       vertical: 20,
  //                     ),
  //                     child: SizedBox(
  //                       width: 328,
  //                       height: 48,
  //                       child: Directionality(
  //                         textDirection: TextDirection.rtl,
  //                         child: TextField(
  //                           controller: controller3,
  //                           decoration: InputDecoration(
  //                             hintText: 'نام',
  //                             enabledBorder: const OutlineInputBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(15)),
  //                               borderSide:
  //                                   BorderSide(color: Colors.red, width: 1.0),
  //                             ),
  //                             focusedBorder: const OutlineInputBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(15)),
  //                               borderSide:
  //                                   BorderSide(width: 1, color: Colors.green),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 328,
  //                     height: 48,
  //                     child: Directionality(
  //                       textDirection: TextDirection.rtl,
  //                       child: TextField(
  //                         controller: controller4,
  //                         decoration: InputDecoration(
  //                           hintText: 'نام خانوادگی',
  //                           enabledBorder: const OutlineInputBorder(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(15)),
  //                             borderSide:
  //                                 BorderSide(color: Colors.red, width: 1.0),
  //                           ),
  //                           focusedBorder: const OutlineInputBorder(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(15)),
  //                             borderSide:
  //                                 BorderSide(width: 1, color: Colors.green),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 20),
  //                     child: SizedBox(
  //                       width: 328,
  //                       height: 48,
  //                       child: ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(16),
  //                           ),
  //                           backgroundColor: Color(0xff2E8530),
  //                         ),
  //                         onPressed: () {
  //                           BlocProvider.of<AuthBloc>(context).add(
  //                             AuthVerifingRequest(
  //                               controller.text,
  //                               controller.text,
  //                               controller3.text,
  //                               controller4.text,
  //                               controller2.text.toString(),
  //                             ),
  //                           );
  //                           // if (controller.text.isNotEmpty) {
  //                           //   setState(() {
  //                           //     isTapped = true;
  //                           //     isTapped2 = true;
  //                           //   });
  //                           //   _timer?.cancel();
  //                           //   startTimer(); // Start the countdown timer when button is pressed
  //                           // }
  //                         },
  //                         child: Text(
  //                           'ثبت نام و ورود',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _selectItem(BuildContext context, String item) {
    Navigator.pop(context); // Close the modal sheet
    // Perform actions based on selected item
    print('Selected item: $item');
  }
}
