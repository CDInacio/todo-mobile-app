import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../providers/taskItem.dart';
import '../providers/auth.dart';

class UserTasks extends StatefulWidget {
  @override
  State<UserTasks> createState() => _UserTasksState();
}

class _UserTasksState extends State<UserTasks> {
  final DateTime _today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final taskItem = Provider.of<TaskItem>(context);
    final parsedDate = DateTime.parse(taskItem.dateTime!);
    final formatedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    final daysLeft = parsedDate.difference(_today).inDays;
    final authData = Provider.of<Auth>(context, listen: false);
    return Dismissible(
      key: ValueKey(taskItem.id),
      background: Container(
        color: Colors.deepOrange,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Tasks>(context, listen: false).deleteTask(taskItem.id!);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        elevation: 2,
        color: Colors.blue,
        child: ListTile(
          leading: Consumer<TaskItem>(
            builder: (context, taskItemData, _) => IconButton(
              icon: Icon(taskItemData.isDone
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: () {
                taskItemData.setTaskAsDone(authData.userId!, authData.token!);
              },
              color: Colors.red,
            ),
          ),
          title: Text(taskItem.body!, maxLines: 1),
          subtitle: Text(formatedDate),
          trailing: daysLeft == 0
              ? const Text('Hoje',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold))
              : null,
        ),
      ),
    );
  }
}
