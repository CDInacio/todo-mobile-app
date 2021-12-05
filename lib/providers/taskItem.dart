// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './helpers/http_Exeption.dart';

class TaskItem with ChangeNotifier {
  final String? body;
  final String? dateTime;
  final String? id;
  bool isDone = false;

  TaskItem({this.body, this.dateTime, this.id, this.isDone = false});

  Future<void> setTaskAsDone(String userId, String authToken) async {
    final old = isDone;
    isDone = !isDone;
    notifyListeners();
    final url = Uri.parse(
        'https://todo-app-a1f6f-default-rtdb.firebaseio.com/doneTasks/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(url, body: json.encode(isDone));
    } catch (error) {
      isDone = old;
      notifyListeners();
    }
  }
}
