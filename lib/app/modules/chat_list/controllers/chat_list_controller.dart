import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> chatGroups = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatGroups();
  }

  void fetchChatGroups() {
    _firestore.collection('groups').snapshots().listen((snapshot) {
      chatGroups.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
        };
      }).toList();
    });
  }

  Future<void> createChatGroup(String groupName) async {
    if (groupName.trim().isEmpty) return;
    await _firestore.collection('groups').add({
      'name': groupName.trim(),
    });
  }
}