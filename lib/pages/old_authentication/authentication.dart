import 'package:bitcoin_cost_average/controllers/auth_controller.dart';
import 'package:bitcoin_cost_average/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../contants.dart';
/*
class AuthLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('en', 'US'),
      // translations will be displayed in that locale
      fallbackLocale: Locale('en', 'US'),
      initialRoute: authenticationPageRoute,
      translationsKeys: Messages().keys,
      unknownRoute:
          GetPage(name: '/not-found', page: () => PageNotFound(), transition: Transition.fadeIn),
      getPages: [
        GetPage(name: authenticationPageRoute, page: () => AuthenticationPage()),
        GetPage(name: authenticationSignUpPageRoute, page: () => SignupPage()),
        GetPage(name: authenticationRecoveryPageRoute, page: () => RecoveryPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'app_name'.tr,
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme:
            GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.blue,
      ),
      //home: AuthenticationPage(),
    );
  }
}*/

class AuthenticationPage extends GetView<AuthController> {
  //todo test user
  TextEditingController _userController = TextEditingController(text: "sgarbi.rodrigo@gmail.com");
  TextEditingController _passwordController = TextEditingController(text: "1234.qwer");
  String _errorEmail, _errorPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Image.asset("assets/icons/logo.png"),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text("login".tr,
                      style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomText(
                    text: 'login_welcome_message'.tr,
                    color: lightGrey,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                    labelText: "Email".tr,
                    hintText: "abc@domain.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorText: _errorEmail),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: "password".tr,
                    hintText: "123",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorText: _errorPassword),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(() {
                        return Checkbox(
                            value: controller.rememberMe.isTrue,
                            onChanged: (value) {
                              controller.rememberMe.toggle();
                            });
                      }),
                      CustomText(
                        text: 'remember_me'.tr,
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(authenticationRecoveryPageRoute);
                      },
                      child: CustomText(text: 'forgot_password_question'.tr, color: active))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  controller.signIn(_userController.text, _passwordController.text);
                },
                child: Container(
                  decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "login".tr,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'not_registered_question'.tr),
                    TextSpan(
                      text: 'sign_up'.tr,
                      style: TextStyle(color: active),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.toNamed(authenticationSignUpPageRoute),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
