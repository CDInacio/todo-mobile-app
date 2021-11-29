import 'package:flutter/material.dart';

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
          const ListTile(
            leading: Icon(Icons.edit),
            title: Text('Criar tarefas'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Minhas informações'),
          ),
        ],
      ),
    );
  }
}
