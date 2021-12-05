import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/add_task_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
              backgroundColor: Colors.deepOrange,
              automaticallyImplyLeading: false),
          const ListTile(
            leading: Icon(Icons.home),
            title: Text('Tarefas'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Criar tarefas'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AddTaskScreen.addTaskRouteName);
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Minhas informações'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
