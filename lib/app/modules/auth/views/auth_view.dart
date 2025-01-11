import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          onPressed: () async {
            User? user = await controller.signInWithGoogle();
            if (user != null) {
        /*      Get.offAllNamed(Routes.CHAT, arguments: {
                'groupId': 'TwinkleChat',
                'userName': user.displayName
              });*/

              Get.offAllNamed(Routes.CHAT_LIST);
            }
          },
          child: const Text(
            'Continue with Google',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
