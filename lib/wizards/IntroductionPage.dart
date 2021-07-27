import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';

class IntroductionPage extends StatefulWidget {

  IntroductionPage();

  @override
  State<StatefulWidget> createState() {
    return _IntroductionPageState();
  }
}

class _IntroductionPageState extends State<IntroductionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  var userController = Get.find<UserController>();
  Widget _buildImage(String assetName, [double width = 256]) {
    return Image.asset('assets/images/introduction/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const Color col = Colors.white;
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: col,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      showNextButton: false,
      showSkipButton: true,
      skip: TextButton(
        onPressed: () {
          updateUser();
        },
        child: Text("Skip"),
      ),
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome",
          body:
              "Bitcoin Cost Average strategy consists in investing a fixed amount of money on regular time interval.",
          image: _buildImage('logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Practical Example",
          body:
              "It\'s January 1st, 2018, and John and Alice decides to purchase \$5,000 worth of Bitcoin.",
          image: _buildImage('bag.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "One time buy",
          body:
              "John decides to purchase today. The Bitcoin price at the time was \$13,800 per coin, which means that John now owns 0.362 BTC.",
          image: _buildImage('john.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Cost Averaging",
          body:
              "Alice decides she wants to purchase \$500 every month, for 10 months. 10 months later, Alice owns 0.61 BTC. ",
          image: _buildImage('anna.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "In the end...",
          body:
              "Alice has almost TWICE as much as John, even though they invested the same amount!",
          image: _buildImage(
            'result.png',
          ),
          decoration: pageDecoration,
        ),
      ],
      done:
          const Text("Connect", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        updateUser();
      },
    );
  }
  void updateUser(){
    FirebaseFirestore.instance
        .collection("users")
        .doc(userController.user.uid)
        .update({"hasIntroduced": true}).then((value) {
      //Navigator.of(context).pop();
      userController.refreshUserData();
    });
  }
}
