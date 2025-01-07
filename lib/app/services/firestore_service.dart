import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages(String groupId) {
    return _db.collection('groups').doc(groupId).collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage(String groupId, String message, String userId) async {
    await _db.collection('groups').doc(groupId).collection('messages').add({
      'text': message,
      'userName': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    return _db.collection('users').doc(userId).get();
  }

  Future<void> createUser(String userId, String? email, String? displayName) async {
    await _db.collection('users').doc(userId).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<bool> getTypingStatus(String groupId) {
    return _db.collection('groups').doc(groupId).snapshots().map((doc) {
      return doc.data()?['isTyping'] ?? false;
    });
  }

  Future<void> updateTypingStatus(String groupId, bool isTyping) async {
    await _db.collection('groups').doc(groupId).update({
      'isTyping': isTyping,
    });
  }
}