import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user.dart';
import 'api.dart';


class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _accessToken = '';
  late Future<User> user;
  late User userdata;

  @override
  void initState() {
    super.initState();
    user = _loadProfileData();
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

  Future<User> _loadProfileData() async {
    http.Response response = await Api().getProfile();

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return User(data['username'], data['email'], data['first_name'], data['last_name']);
    } else {
      _showMessage('Ошибка', jsonDecode(response.body).toString());
      throw Error();
    }
  }

  void _updateProfileData() async {
    http.Response response = await Api().updateProfile(userdata);

    if (response.statusCode == 200) {
      _showMessage('Изменение данных', 'Данные о вашем профиле изменены');
    } else {
      _showMessage('Ошибка', jsonDecode(response.body).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot){
          if(snapshot.hasData){
            userdata = snapshot.data!;
            return SafeArea(
                    child: ListView(
                      padding: EdgeInsets.all(20.0),
                      children: [
                        TextFormField(
                          initialValue: userdata.username,
                          onChanged: (value) => setState(() => userdata.username = value),
                          decoration: InputDecoration(labelText: "Логин"),
                        ),
                        TextFormField(
                          initialValue: userdata.email,
                          onChanged: (value) => setState(() => userdata.email = value),
                          decoration: InputDecoration(labelText: "Почта"),
                        ),
                        TextFormField(
                          initialValue: userdata.first_name,
                          onChanged: (value) => setState(() => userdata.first_name = value),
                          decoration: InputDecoration(labelText: "Имя"),
                        ),
                        TextFormField(
                          initialValue: userdata.last_name,
                          onChanged: (value) => setState(() => userdata.last_name = value),
                          decoration: InputDecoration(labelText: "Фамилия"),
                        ),
                        ElevatedButton(
                          onPressed: _updateProfileData,
                          child: Text("Сохранить"),
                        )
                      ]
                    )
                  );
          } else if (snapshot.hasError){
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
