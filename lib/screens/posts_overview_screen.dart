import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// widgets
import '../drawer.dart';
//screens
import '../screens/add_task_screen.dart';

class PostsOverViewScreen extends StatelessWidget {
  const PostsOverViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime _data = DateTime.now();
    var formatedDate = DateFormat("d 'de' MMMM 'de' y", "pt_BR").format(_data);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          formatedDate,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed(AddTaskScreen.addTaskRouteName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
