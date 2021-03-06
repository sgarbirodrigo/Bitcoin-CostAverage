import 'package:bitcoin_cost_average/auth_pages/forgotPassword.dart';
import 'package:bitcoin_cost_average/auth_pages/signIn.dart';
import 'package:bitcoin_cost_average/auth_pages/signUp.dart';
import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/auth_controller.dart';
import 'package:bitcoin_cost_average/widgets/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final GlobalKey<ScaffoldState> _authScaffoldKey = GlobalKey<ScaffoldState>();

  PageController authPageController = PageController(keepPage: true, initialPage: 1);
  int page = 1;
  SnackBar networkErrorSnackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 15,
          color: Colors.white,
        ),
        SizedBox(
          width: 4,
        ),
        Text("no_connection".tr)
      ],
    ),
  );

  // Change Page Button Preffixs
  List<String> preffix = [
    "cancel_reset_password".tr,
    "need_account".tr,
    "have_account".tr,
  ];

  // Change Page Button Suffixs
  List<String> suffix = [
    "sign_in".tr,
    "sign_up".tr,
    "sign_in".tr,
  ];
  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _authScaffoldKey,
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                authController.signOut();
              },
            )
          : null,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo Template
                      Container(
                        height: 128,
                        width: 128,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          //color: Colors.grey,
                        ),
                        child: Center(
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        text: "title".tr,
                        color: active,
                        size: 24,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    // PageView To Display Auth Pages
                    child: PageView(
                      controller: authPageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        if(mounted)setState(() {
                          page = value;
                        });
                      },
                      children: [
                        // Forgot Password Page
                        ForgotPassword(
                          authPageController: authPageController,
                          authScaffoldKey: _authScaffoldKey,
                          networkErrorSnackBar: networkErrorSnackBar,
                        ),

                        // SignIn Page
                        SignIn(
                          authPageController: authPageController,
                          authScaffoldKey: _authScaffoldKey,
                          networkErrorSnackBar: networkErrorSnackBar,
                        ),

                        // SignUp Page
                        SignUp(
                          authScaffoldKey: _authScaffoldKey,
                          networkErrorSnackBar: networkErrorSnackBar,
                        ),
                      ],
                    ),
                  ),
                  // Change Page Button
                  //Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      if (authPageController.page == 2) {
                        authPageController.previousPage(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOutCirc,
                        );
                      } else {
                        authPageController.nextPage(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOutCirc,
                        );
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        text: preffix[page],
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        //style: Theme.of(context).textTheme.headline6,
                        children: <TextSpan>[
                          TextSpan(
                              text: suffix[page],
                              style: TextStyle(color: Theme.of(context).primaryColor))
                          //style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
