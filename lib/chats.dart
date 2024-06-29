import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user.dart';
import 'api.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<ChatsPage> createState() => _Chats();
}

class _Chats extends State<ChatsPage>  {
  late Future<List<User>> users;
  late List<User> usersData;

  @override
  void initState() {
    super.initState();
    users = _getUsers();
  }
  void _showMessage(String title, String content) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
    );
  }

  Future<List<User>> _getUsers() async {
    http.Response response = await Api().getUsers();

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      List<User> users = List<User>.from(data.map((json) => User(json['username'], json['email'], json['first_name'], json['last_name'])));
      return users;
    } else {
      _showMessage('Ошибка', jsonDecode(response.body).toString());
      throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пользователи'),
      ),
      body: FutureBuilder<List<User>>(
              future: users,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  usersData = snapshot.data!;
                  return ListView.builder(
                    itemCount: usersData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(usersData[index].username),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage(user: usersData[index])),
                          );
                        },
                      );
                    },
                  );
                }else if (snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                }
                else{
                  return const CircularProgressIndicator();
                }
            }
      )
    );
  }
}

class ChatPage extends StatelessWidget {
  final User user;
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();

  ChatPage({required this.user});

  @override
  Widget build(BuildContext context) {

    void sendMessage() {
      String message = messageController.text;
      if (message.isNotEmpty) {
          messages.add(message);
          messageController.clear();
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Сообщения'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            messages[index],
                          )
                      ));
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Сообщение...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }


}

