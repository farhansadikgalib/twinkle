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
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  return Align(
                    alignment:
                        isSender ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      padding: REdgeInsets.all(8.0),
                      margin:
                          REdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
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
                  );
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
                      icon:
                          const Icon(Icons.send, color: Colors.blue, size: 35),
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
}
