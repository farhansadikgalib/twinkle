import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firestore_service.dart';

class ChatController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final messages = <QueryDocumentSnapshot>[].obs;
  final messageController = TextEditingController();
  final isTyping = false.obs;
  late String groupId;
  late String userId;

  @override
  void onInit() {
    super.onInit();
    groupId = Get.arguments['groupId'];
    userId = Get.arguments['userName'];
    _firestoreService.getMessages(groupId).listen((snapshot) {
      messages.value = snapshot.docs;
    });
    _firestoreService.getTypingStatus(groupId).listen((status) {
      isTyping.value = status;
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      _firestoreService.sendMessage(groupId, messageController.text, userId);
      messageController.clear();
      _firestoreService.updateTypingStatus(groupId, false);
    }
  }

  void updateTypingStatus(bool typing) {
    _firestoreService.updateTypingStatus(groupId, typing);
  }
}