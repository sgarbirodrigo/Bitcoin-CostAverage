import 'package:Bit.Me/controllers/auth_controller.dart';
import 'package:Bit.Me/widgets/custom_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../contants.dart';

class RecoveryController extends GetxController {
  final String title = 'My Awesome View';
}

// ALWAYS remember to pass the `Type` you used to register your controller!
class RecoveryPage extends GetView<RecoveryController> {
  final authController = Get.put(AuthController());
  TextEditingController _userController = TextEditingController();
  String _errorEmail;

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
                  Text("recover".tr,
                      style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
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
              InkWell(
                onTap: () {
                  authController.recover(_userController.text);
                },
                child: Container(
                  decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "recover".tr,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'registered_question'.tr),
                TextSpan(
                  text: 'login'.tr,
                  style: TextStyle(color: active),
                  recognizer: TapGestureRecognizer()..onTap = ()  {
                    if(Get.previousRoute == authenticationPageRoute){
                      Get.back();
                    }else{
                      Get.toNamed(authenticationPageRoute);
                    }
                  },
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
