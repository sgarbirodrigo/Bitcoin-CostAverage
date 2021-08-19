import 'dart:convert';
import 'package:bitcoin_cost_average/controllers/auth_controller.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/external/qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../external/binance_api.dart';
import '../models/user_model.dart';

class ConnectToBinancePage extends StatefulWidget {
  ConnectToBinancePage();

  @override
  State<StatefulWidget> createState() {
    return _ConnectToBinancePageState();
  }
}

class _ConnectToBinancePageState extends State<ConnectToBinancePage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final _formKey = GlobalKey<FormState>();
  int _selectedStatus = 0;
  bool _readingQRCode = false;
  TextEditingController privatekey_controller;
  TextEditingController publickey_controller;
  var userController = Get.find<UserController>();
  var authController = Get.find<AuthController>();

  Widget _buildImage(String assetName, [double width = 256]) {
    return Image.asset('assets/images/introduction/$assetName', width: width);
  }

  @override
  void initState() {
    privatekey_controller = TextEditingController();
    publickey_controller = TextEditingController();
    publickey_controller.text = userController.user.public_key;
    privatekey_controller.text = userController.user.private_key;

    _selectedExchange = _exchanges[0];
  }

  int index = 0;
  List<String> _exchanges = ["Binance"];
  String _selectedExchange;

  @override
  Widget build(BuildContext context) {
    const Color col = Colors.white;
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      pageColor: col,
      imagePadding: EdgeInsets.zero,
    );
    print("index $index");
    return IntroductionScreen(
      showNextButton: false,
      globalBackgroundColor: Colors.white,
      showSkipButton: true,
      skip: TextButton(
        onPressed: () {
          updateUser();
        },
        child: Text("skip".tr),
      ),
      //freeze: this.index==4,
      showDoneButton: true,
      done: TextButton(
        onPressed: () {
          updateUser();
        },
        child: Text("skip".tr),
      ),
      onDone: (){},
      dotsDecorator: DotsDecorator(
          size: const Size.square(12.0),
          activeSize: const Size(36.0, 12.0),
          activeColor: Colors.deepPurple,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 2.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
      onChange: (index) {
        this.index = index;
      },
      key: introKey,
      pages: [
        PageViewModel(
          title: "how_work".tr,
          /*body:
              "We connect to your Exchange account and automatically execute your predefined orders daily at 11PM",*/
          bodyWidget: Container(
            child: Column(
              children: [
                Text(
                  "how_work_text".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "exchange".tr,
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        //width: 128,
                        child: DropdownButton<String>(
                          value: _selectedExchange,
                          items: _exchanges.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedExchange = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                kDebugMode
                    ? ElevatedButton(
                        onPressed: () {
                          authController.signOut();
                        },
                        child: Text("logOut"))
                    : Container()
              ],
            ),
          ),
          image: _buildImage(
            'link.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "lets_connect".tr,
          body:
          "lets_Connect_text".tr,
          image: _buildImage(
            'binance.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "creating_api".tr,
          body:
          "creating_api_text".tr,
          image: _buildImage(
            'api_1.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "saving_api".tr,
          body:
          "saving_api_text".tr,
          image: _buildImage(
            'api_config.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(top: 32),
            height: 128,
            width: 128,
            //padding: EdgeInsets.only(bottom: ),
            child: _readingQRCode
                ? QRViewExample((Barcode barcode) {
                    try {
                      Map<String, dynamic> response = jsonDecode(barcode.code);
                      print("resp: $response");
                      if (response["apiKey"] != null && response["secretKey"] != null) {
                        publickey_controller.text = response["apiKey"];
                        privatekey_controller.text = response["secretKey"];
                        setState(() {
                          _readingQRCode = false;
                        });
                      } else {
                        print("invalid QRCODE");
                        //todo add snackbar invalid qrcode
                      }
                    } catch (e) {
                      print("invalid QRCODE ${e}");
                      //todo add snackbar invalid qrcode
                    }
                  })
                : Image.asset('assets/images/link.png'),
          ),
          useScrollView: true,
          bodyWidget: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                    //height: 520,
                    child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFormField(
                          controller: publickey_controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.public),
                              labelText: "api_key".tr),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "enter_value".tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: privatekey_controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outlined),
                              labelText: "secret_key".tr),
                          onChanged: (value) {},
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "enter_value".tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _readingQRCode = !_readingQRCode;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code,
                              color: Colors.white,
                            ),
                            Container(
                              width: 16,
                            ),
                            Text("readQR".tr)
                          ],
                        ),
                      ),
                      Container(
                        height: 8,
                      ),
                      GestureDetector(
                        child: Text(
                        "get_API_keys".tr,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        ),
                        onTap: () {
                          launch('https://www.binance.com/en/my/SettingsApp/api-management');
                        },
                      ),
                      Container(
                        height: 16,
                      ),
                      ElevatedButton(
                        child: Container(
                          /*padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 24),*/
                          child: _selectedStatus == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    "save".tr,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              : _selectedStatus == 1
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 32, bottom: 24, top: 24, right: 24),
                                          child: Text(
                                            "saving".tr,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          height: 32,
                                          width: 32,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                          ),
                                        ),
                                        Container(
                                          width: 16,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 32, bottom: 24, top: 24, right: 16),
                                          child: Text("saved".tr, style: TextStyle(fontSize: 18)),
                                        ),
                                        Container(
                                          height: 32,
                                          width: 32,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.grey,
                                            size: 32,
                                          ),
                                        ),
                                        Container(
                                          width: 8,
                                        )
                                      ],
                                    ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                          /*side:
                                        BorderSide(color: Colors.deepPurple)*/
                        ))),
                        onPressed: _selectedStatus != 0
                            ? null
                            : () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _selectedStatus = 1;
                                  });
                                  // print("${_selectedStatus}");
                                  if (await areUserKeysNewCorrect(
                                      privatekey_controller.text, publickey_controller.text)) {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(userController.user.uid)
                                        .update({
                                      "private_key": privatekey_controller.text,
                                      "public_key": publickey_controller.text,
                                      "hasConnected": true,
                                      "lastUpdatedTimestamp": Timestamp.now()
                                    }).then((value) {
                                      if (mounted)
                                        setState(() {
                                          _selectedStatus = 2;
                                        });
                                      if (mounted) setState(() {});
                                      Future.delayed(const Duration(milliseconds: 4000), () {
                                        if (mounted)
                                          setState(() {
                                            _selectedStatus = 0;
                                          });
                                      });
                                    });
                                    userController.refreshUserData();
                                  } else {
                                    setState(() {
                                      _selectedStatus = 0;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                      "api_invalid".tr,
                                        textAlign: TextAlign.left,
                                      ),
                                      duration: Duration(seconds: 4),
                                      behavior: SnackBarBehavior.fixed,
                                      /* action: SnackBarAction(
                                      label: 'OK',
                                      textColor: Colors.yellow,
                                      onPressed: () {
                                        //  Navigator.of(context).pop();
                                      },

                                    )*/
                                    ));
                                  }
                                }
                              },
                      )
                    ],
                  ),
                )),
              )),
          /*image: _buildImage(
            'connect.png',
          ),*/
          decoration: pageDecoration,
        ),
      ],
    );
  }
  void updateUser() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userController.user.uid)
        .update({"hasConnected": true}).then((value) {
      //Navigator.of(context).pop();
      userController.refreshUserData();
    });
  }
}
