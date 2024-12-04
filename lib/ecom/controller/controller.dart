import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isDarkMode = (Get.isDarkMode).obs;

  // Toggle dark mode state
  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }
}
