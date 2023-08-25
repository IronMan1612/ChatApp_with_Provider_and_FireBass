import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/all_widgets.dart';
import '../model/state_of_application.dart';

class LetUsChatMessage {
  LetUsChatMessage({required this.name, required this.message, required this.isMe, required this.timestamp});
  final String name;
  final String message;
  final bool isMe;
  final DateTime timestamp;  // Thêm trường thời gian
}


class LetUsChat extends StatefulWidget {
  const LetUsChat({required this.addMessage, required List<LetUsChatMessage> messages});
  final FutureOr<void> Function(String message) addMessage;

  @override
  _LetUsChatState createState() => _LetUsChatState();
}
class _LetUsChatState extends State<LetUsChat> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _submitMessage() {                     // hàm gửi tin nhắn khi nhấn nút send or enter
    if (_formKey.currentState!.validate()) {
      _addMessage(_controller.text);
      _controller.clear();
    }
  }

  void _addMessage(String messageContent) async {
    await widget.addMessage(messageContent);
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<StateOfApplication>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MessageSearch(state.chatBookMessages),
              );
            },
          ),
        ],
      ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.chatBookMessages.length,
                  itemBuilder: (ctx, index) {
                    final message = state.chatBookMessages[index];
                    final isUserMessage = message.isMe;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment:
                        isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(ctx).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isUserMessage ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: isUserMessage ? Radius.circular(15) : Radius.circular(0),
                                  bottomRight: isUserMessage ? Radius.circular(0) : Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isUserMessage ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    message.message,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isUserMessage ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    DateFormat('hh:mm a').format(message.timestamp),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isUserMessage ? Colors.white.withOpacity(0.7) : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Start Chatting',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your message to continue';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) => _submitMessage(), //gọi hàm gửi tin
                        ),
                      ),
                      const SizedBox(width: 10),
                      StyledButton(
                        onPressed: _submitMessage,
                        child: Row(
                          children: const [
                            Icon(Icons.send),
                            SizedBox(width: 6),
                            Text('SEND'),
                          ],
                        ),
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

class MessageSearch extends SearchDelegate<LetUsChatMessage?> {
  final List<LetUsChatMessage> messages;

  MessageSearch(this.messages);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = messages.where((message) {
      return message.message.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final message = suggestions[index];
        return ListTile(
          title: Text(message.message),
          onTap: () {
            close(context, message);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Click on a suggestion to view the full message.'),
    );
  }
}
