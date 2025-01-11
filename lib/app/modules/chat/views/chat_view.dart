import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.scrollController.hasClients) {
          controller.scrollController
              .jumpTo(controller.scrollController.position.maxScrollExtent);
        }
      });

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.blue.withOpacity(0.8),
          title: Text(Get.arguments['groupName'].toString(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                shrinkWrap: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isSender = message['userName'] == controller.userName.value;
                  final messageWidget = FractionallySizedBox(
                    widthFactor: 0.8,
                    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: GestureDetector(
                      onLongPress: isSender
                          ? () {
                              _showEditDialog(context, message['id'], message['text']);
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!isSender && message['photoURL'] != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(message['photoURL']),
                                radius: 20,
                              ),
                            if (isSender && controller.userPhotoUrl.value != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(controller.userPhotoUrl.value),
                                radius: 20,
                              ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: isSender ? Colors.blue[100] : Colors.green[100],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['userName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSender ? Colors.blue : Colors.green,
                                      ),
                                    ),
                                    Text(message['text']),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  return isSender
                      ? Dismissible(
                          key: ValueKey(message['id']),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            HapticFeedback.heavyImpact();
                            controller.deleteMessage(message['id']);
                          },
                          child: messageWidget,
                        )
                      : messageWidget;
                },
              ),
            ),
            if (controller.typingUser.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${controller.typingUser} is typing...'),
              ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: BottomAppBar(
                color: Theme.of(context).canvasColor,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.blue,
                        controller: controller.messageController,
                        decoration: InputDecoration(
                          hintText: controller.isTyping.value
                              ? 'Someone is typing...'
                              : 'Enter your message',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        onChanged: (text) {
                          controller.updateTypingStatus(text.isNotEmpty);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue, size: 35),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        controller.sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showEditDialog(BuildContext context, String messageId, String currentText) {
    final TextEditingController editController = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          content: Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: Colors.white,
            ),
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Update your message',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                suffix: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    controller.updateMessage(messageId, editController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}