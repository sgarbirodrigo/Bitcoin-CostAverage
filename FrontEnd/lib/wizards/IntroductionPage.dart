import 'package:bitcoin_cost_average/controllers/user_controller.dart';
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
        child: Text("skip".tr),
      ),
      key: introKey,
      pages: [
        PageViewModel(
          title: "welcome".tr,
          body: "welcome_text".tr,
          image: _buildImage('logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "practical_example".tr,
          body: "practical_example_text".tr,
          image: _buildImage('bag.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "one_time_buy".tr,
          body: "one_time_buy_text".tr,
          image: _buildImage('john.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "cost_averaging".tr,
          body: "cost_averaging_text".tr,
          image: _buildImage('anna.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "in_the_end".tr,
          body: "in_the_end_text".tr,
          image: _buildImage(
            'result.png',
          ),
          decoration: pageDecoration,
        ),
      ],
      done: Text("connect".tr, style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        updateUser();
      },
    );
  }

  void updateUser() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userController.user.uid)
        .update({"hasIntroduced": true}).then((value) {
      //Navigator.of(context).pop();
      userController.refreshUserData();
    });
  }
}
