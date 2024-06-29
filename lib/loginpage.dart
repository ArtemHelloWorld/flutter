import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  void _showMessage(String title, String content) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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

  void _saveData(String refreshToken, String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', refreshToken);
    await prefs.setString('accessToken', accessToken);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/token/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _username,
          'password': _password,
        }),
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        _saveData(data['refresh'], data['access']);
        _showMessage('Вы вошли в аккуант', 'Теперь вам доступен весь функционал');
      } else {
        _showMessage('Ошибка', jsonDecode(response.body).toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Логин'),
                onChanged: (value) {
                  _username = value;
                },
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                onChanged: (value) {
                  _password = value;
                },
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
