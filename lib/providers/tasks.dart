import 'package:flutter/material.dart';

import './taskItem.dart';

class Tasks with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<TaskItem> _tasks = [];

  Tasks({this.authToken, this.userId});
}
