import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firestore_service.dart';

class ChatController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final messages = <QueryDocumentSnapshot>[].obs;
  final messageController = TextEditingController();
  final isTyping = false.obs;
  late String groupId;
  late String userName;
  final ScrollController scrollController = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void onInit() {
    super.onInit();
    groupId = Get.arguments['groupId'];
    userName = Get.arguments['userName'];
    _firestoreService.getMessages(groupId).listen((snapshot) {
      messages.value = snapshot.docs;
    });
    _firestoreService.getTypingStatus(groupId).listen((status) {
      if (status['userName'] != userName) {
        isTyping.value = status['isTyping'];
      }
    });
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      _firestoreService.sendMessage(groupId, messageController.text, userName);
      messageController.clear();
      _firestoreService.updateTypingStatus(groupId, userName, false);
    }
  }

  void deleteMessage(String messageId) {
    _firestoreService.deleteMessage(groupId, messageId);
  }

  void updateMessage(String messageId, String newText) {
    _firestoreService.updateMessage(groupId, messageId, newText);
  }

  void updateTypingStatus(bool typing) {
    _firestoreService.updateTypingStatus(groupId, userName, typing);
  }
}