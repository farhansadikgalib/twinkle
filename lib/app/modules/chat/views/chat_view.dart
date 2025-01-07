import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          backgroundColor: Colors.blue.withOpacity(0.8),
          title: const Text('Twinkle Group',
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
                  final isSender = message['userName'] == controller.userName;
                  final messageWidget = FractionallySizedBox(
                    widthFactor: 0.8,
                    alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
                    child: GestureDetector(
                      onLongPress: isSender
                          ? () {
                              _showEditDialog(context, message.id, message['text']);
                            }
                          : null,
                      child: Container(
                        padding: REdgeInsets.all(8.0),
                        margin: REdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(8.0).r,
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
                  );

                  return isSender
                      ? Dismissible(
                          key: ValueKey(message.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: REdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            HapticFeedback.heavyImpact();
                            controller.deleteMessage(message.id);
                          },
                          child: messageWidget,
                        )
                      : messageWidget;
                },
              ),
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
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 1.5),
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
          contentPadding: REdgeInsets.symmetric(horizontal: 10, vertical: 10),
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