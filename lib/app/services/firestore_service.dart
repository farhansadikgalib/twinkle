import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages(String groupId) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> sendMessage(
      String groupId, String message, String userName, String? photoURL) async {
    await _db.collection('groups').doc(groupId).collection('messages').add({
      'text': message,
      'userName': userName,
      'photoURL': photoURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<Map<String, dynamic>> getTypingStatus(String groupId) {
    return _db.collection('groups').doc(groupId).snapshots().map((doc) {
      return {
        'isTyping': doc.data()?['isTyping'] ?? false,
        'userName': doc.data()?['userName'] ?? '',
      };
    });
  }

  Future<void> updateTypingStatus(
      String groupId, String userName, bool isTyping) async {
    final docRef = _db.collection('groups').doc(groupId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.update({'isTyping': isTyping, 'userName': userName});
    } else {
      await docRef.set({'isTyping': isTyping, 'userName': userName});
    }
  }

  Future<void> deleteMessage(String groupId, String messageId) async {
    try {
      await _db.collection('groups').doc(groupId).collection('messages').doc(messageId).delete();
    } catch (e) {
      debugPrint('Error deleting message: $e');
    }
  }

  Future<void> updateMessage(String groupId, String messageId, String newText) async {
    try {
      await _db.collection('groups').doc(groupId).collection('messages').doc(messageId).update({
        'text': newText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating message: $e');
    }
  }

  Stream<QuerySnapshot> getChatGroups() {
    return _db.collection('groups').snapshots();
  }

  Future<void> addGroupChat(String name) async {
    await _db.collection('groups').add({
      'name': name,
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    return _db.collection('users').doc(userId).get();
  }

  Future<void> createUser(String userId, String? email, String? displayName, String? photoURL) async {
    await _db.collection('users').doc(userId).set({
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}