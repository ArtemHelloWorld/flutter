import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';

class Api {
  String accessToken = '';


  Future<http.Response> getProfile() async {
    accessToken = await _loadAccessToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/profile/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
   return response;
  }

  Future<http.Response> updateProfile(User userdata) async {
    accessToken = await _loadAccessToken();
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/v1/profile/'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': userdata.username,
        'email': userdata.email,
        'first_name': userdata.first_name,
        'last_name': userdata.last_name,
      }),
    );
    return response;
  }

  Future<http.Response> getUsers() async {
    accessToken = await _loadAccessToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/users/list/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  Future<String> _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }
}