import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firestore_service.dart';

class ChatController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString userName = ''.obs;
  final RxString userPhotoUrl = ''.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool isTyping = false.obs;
  final RxString typingUser = ''.obs;
  final String groupId= Get.parameters['groupId'] ?? '';


  @override
  void onInit() {
    super.onInit();
    userName.value = _auth.currentUser?.displayName ?? '';
    userPhotoUrl.value = _auth.currentUser?.photoURL ?? '';
    fetchMessages();
    fetchTypingStatus();
  }

  void fetchMessages() {
    _firestoreService.getMessages(groupId).listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'text': data['text'],
          'userName': data['userName'],
          'photoURL': data['photoURL'] ?? '',        };
      }).toList();
    });
  }

  void fetchTypingStatus() {
    _firestoreService.getTypingStatus(groupId).listen((status) {
      typingUser.value = status['isTyping'] ? status['userName'] : '';
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    await _firestoreService.sendMessage(
      groupId,
      messageController.text.trim(),
      userName.value,
      userPhotoUrl.value,
    );
    messageController.clear();
    updateTypingStatus(false);
  }

  void updateTypingStatus(bool typing) {
    isTyping.value = typing;
    _firestoreService.updateTypingStatus(groupId, userName.value, typing);
  }

  Future<void> deleteMessage(String messageId) async {
    await _firestoreService.deleteMessage(groupId, messageId);
  }

  Future<void> updateMessage(String messageId, String newText) async {
    await _firestoreService.updateMessage(groupId, messageId, newText);
  }
}