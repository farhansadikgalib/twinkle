import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      2.seconds,
          () => Get.offNamed(Routes.AUTH),
    );
  }

}
