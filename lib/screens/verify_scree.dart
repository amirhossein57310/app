import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerifingScreen extends StatefulWidget {
  const VerifingScreen({Key? key}) : super(key: key);

  @override
  State<VerifingScreen> createState() => _VerifingScreenState();
}

class _VerifingScreenState extends State<VerifingScreen> {
  FocusNode negahban1 = FocusNode();
  FocusNode negahban2 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    negahban1.addListener(() {
      setState(() {});
    });
    negahban2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            bottom: 30,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bas.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: double.infinity,
              // ),
              Expanded(child: Text('data')),
              Expanded(
                child: SvgPicture.asset(
                  'assets/images/image3.svg',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    negahban1.dispose();
    negahban2.dispose();
    super.dispose();
  }
}
