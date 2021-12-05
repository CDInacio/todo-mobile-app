import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// widgets
import '../widgets/drawer.dart';
import '../widgets/user_tasks.dart';
//screens
import '../screens/add_task_screen.dart';
// prodivers
import '../providers/tasks.dart';

class PostsOverViewScreen extends StatefulWidget {
  const PostsOverViewScreen({Key? key}) : super(key: key);

  @override
  State<PostsOverViewScreen> createState() => _PostsOverViewScreenState();
}

class _PostsOverViewScreenState extends State<PostsOverViewScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tasks>(context, listen: false).fetchTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);
    final tasksCount = tasksData.tasksCount.toString();
    DateTime _date = DateTime.now();
    var formatedDate = DateFormat("d 'de' MMMM 'de' y", "pt_BR").format(_date);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Suas tarefas ( $tasksCount )',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.deepOrange,
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        minHeight: 56.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasksData.tasks.length,
                        itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                              value: tasksData.tasks[index],
                              child: UserTasks(),
                            )),
                  ),
          )
        ],
      ),
    );
  }
}
