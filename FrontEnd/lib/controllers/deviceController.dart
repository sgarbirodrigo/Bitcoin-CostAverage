import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';

class DeviceController extends GetxController {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  var isSimulator = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("init device");
    testSimulator().then((value) {
      print("is Sim: ${value}");
      return this.isSimulator.value = value;
    });
  }

  Future<bool> testSimulator() async {
    if (Platform.isIOS) {
      IosDeviceInfo info = await _deviceInfo.iosInfo;
      if (!info.isPhysicalDevice) {
        return true;
      } else {
        return false;
      }
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceInfo.androidInfo;
      if (!info.isPhysicalDevice) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
