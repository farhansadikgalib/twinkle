import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.onInit();
    return const Scaffold(
      body: Center(
        child: Text(
          'Twinkle ⭐',
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
