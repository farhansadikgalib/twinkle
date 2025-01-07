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
      appBar: AppBar(
        title: const Text('AuthView'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await controller.signInWithGoogle();
            if (user != null) {
              Get.offAllNamed(Routes.CHAT, arguments: {
                'groupId': 'farDroid',
                'userName': user.displayName
              });
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
