import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tasksController = TextEditingController();

  List<Todo> tasks = [];

  Todo? deletedTask;
  int? deletedTaskIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tasksController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma Tarefa',
                        hintText: 'Ex:. Estudar Flutter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String task = tasksController.text;
                      setState(() {
                        Todo newTodo = Todo(
                          title: task,
                          dateTime: DateTime.now(),
                        );
                        tasks.add(newTodo);
                        tasksController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[700],
                      padding: const EdgeInsets.all(17),
                    ),
                    child: const Icon(
                      Icons.add,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo task in tasks)
                      TodoListItem(
                        task: task,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui ${tasks.length} tarefas pendentes',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: showDeleteTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[700],
                        padding: const EdgeInsets.all(14)),
                    child: const Text('Limpar Tudo'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTask = todo;
    deletedTaskIndex = tasks.indexOf(todo);

    setState(() {
      tasks.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} removida com sucesso!',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              tasks.insert(deletedTaskIndex!, deletedTask!);
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  dynamic showDeleteTodosConfirmationDialog() {
    return (showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Confirmação'),
          content: const Text(
            'Deseja realmente excluir todas as tarefas?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.clear();
                });
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tarefas excluídas com sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.indigo,
                  ),
                );
              },
              child: const Text(
                'Excluir',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
