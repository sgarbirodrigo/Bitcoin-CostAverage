import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(),permanent: true);
  }
}