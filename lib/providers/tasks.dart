import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import './taskItem.dart';

class Tasks with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<TaskItem> _tasks = [];

  Tasks(this.authToken, this.userId, this._tasks);

  List<TaskItem> get tasks {
    return [..._tasks.reversed];
  }

  Future<void> addTask(String body, String date) async {
    var url = Uri.parse(
        'https://todo-app-a1f6f-default-rtdb.firebaseio.com/tasks.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'body': body,
            'dateTime': date,
            'creatorId': userId,
          }));
      final newTask = TaskItem(
        body: body,
        dateTime: date,
        id: json.decode(response.body)['name'],
      );
      _tasks.add(newTask);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchTasks() async {
    final url = Uri.parse(
        'https://todo-app-a1f6f-default-rtdb.firebaseio.com/tasks.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"');
    final doneTaskUrl = Uri.parse(
        'https://todo-app-a1f6f-default-rtdb.firebaseio.com/doneTasks/$userId.json?auth=$authToken');
    try {
      final doneTaskResponse = await http.get(doneTaskUrl);
      final doneTaskData = json.decode(doneTaskResponse.body);
      // print(doneTaskResponse.body);
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data == null) {
        return;
      }
      final List<TaskItem> loadedTasks = [];
      data.forEach((key, value) {
        loadedTasks.add(TaskItem(
            body: value['body'],
            dateTime: value['dateTime'],
            id: key,
            isDone: doneTaskData == null ? false : doneTaskData[key] ?? false));
      });
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteTask(String id) async {
    final url = Uri.parse(
        'https://todo-app-a1f6f-default-rtdb.firebaseio.com/tasks/$id.json?auth=$authToken');
    final existingTaskId = _tasks.indexWhere((element) => element.id == id);
    TaskItem? existingTask = _tasks[existingTaskId];
    _tasks.removeAt(existingTaskId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _tasks.insert(existingTaskId, existingTask);
      notifyListeners();
    }
    existingTask = null;
  }

  int get tasksCount {
    return _tasks.length;
  }
}
