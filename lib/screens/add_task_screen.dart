import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  static const addTaskRouteName = '/add-task';

  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0,
        ),
        backgroundColor: Colors.deepOrange,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adicionar tarefa',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
               const  SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: 'Sua tarera',
                        hintText: 'Escreva sua tarefa aqui...',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide()))),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {},
                      child: const Text('Escrever'),
                    )),
              ],
            ),
          ),
        ));
  }
}
