import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_list_controller.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.8),
        title: const Text('Chat Groups',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateChatDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.chatGroups.length,
          itemBuilder: (context, index) {
            final chatGroup = controller.chatGroups[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    chatGroup['name'][0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  chatGroup['name'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.toNamed('/chat', arguments: {
                    'groupId': chatGroup['id'],
                    'groupName': chatGroup['name'],
                  });
                },
              ),
            );
          },
        );
      }),
    );
  }

  void _showCreateChatDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Chat Group'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter group name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.createChatGroup(nameController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}