import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../providers/tasks.dart';

class AddTaskScreen extends StatefulWidget {
  static const addTaskRouteName = '/add-task';

  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  var _initValues = {'body': '', 'date': ''};
  DateTime? _myDateTime;
  String? _time;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final task = Provider.of<Tasks>(context, listen: false);
    try {
      await task.addTask(_initValues['body']!, _initValues['date']!);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa criada com sucesso!')));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            elevation: 0,
          ),
          backgroundColor: Colors.deepOrange,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
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
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: _initValues['body'],
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: 'Sua tarera',
                        hintText: 'Escreva sua tarefa aqui...',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        border:
                            const OutlineInputBorder(borderSide: BorderSide())),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.length < 10) {
                        return 'A tarefa precisa ter no mínimo 10 caractéres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _initValues['body'] = value!;
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        _time == null
                            ? 'Nenhuma data escolhida ainda.'
                            : _time!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        // focusNode: _dateFocusNode,
                        onPressed: () async {
                          _myDateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2024));

                          setState(() {
                            _time = DateFormat('dd-MM-yy').format(_myDateTime!);
                            _initValues['date'] = _myDateTime.toString();
                          });
                        },
                        child: const Text(
                          'Escolher',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: _submitForm,
                        child: const Text('Escrever'),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
