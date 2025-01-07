import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Twinkle Chat', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                }
              });

              return ListView.builder(
                controller: _scrollController,
                reverse: false,
                shrinkWrap: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isSender = message['userName'] == controller.userName;
                  return Align(
                    alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
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
                  );
                },
              );
            }),
          ),
          Obx(() {
            return controller.isTyping.value
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Someone is typing...'),
                  )
                : Container();
          }),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: BottomAppBar(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                      ),
                      onChanged: (text) {
                        controller.updateTypingStatus(text.isNotEmpty);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: controller.sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}