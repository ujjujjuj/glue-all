// initial bindings
import 'package:get/get.dart';
import 'package:glue/controllers/user_controller.dart';

class Init extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
  }
}
