import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tasksController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> tasks = [];

  Todo? deletedTask;
  int? deletedTaskIndex;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

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
                      decoration: InputDecoration(
                          //espessura da borda
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: 'Adicione uma Tarefa',
                          labelStyle: TextStyle(
                            color: Colors.indigo.shade900,
                          ),
                          hintText: 'Ex:. Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.indigo.shade900,
                                width: 2,
                              ))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String task = tasksController.text;

                      if (task.isEmpty) {
                        setState(() {
                          errorText = 'O tarefa não pode estar vazia!';
                        });
                        return;
                      }

                      setState(() {
                        Todo newTodo = Todo(
                          title: task,
                          dateTime: DateTime.now(),
                          index: DateTime.now(),
                        );
                        tasks.insert(0, newTodo);
                        errorText = null;
                        tasksController.clear();
                        todoRepository.saveTodoList(tasks);
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
                        onCheck: onCheck,
                        index: DateTime.now(),
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

  void onCheck(Todo task) {
    setState(() {
      task.isDone = !task.isDone;
      tasks.remove(task);
      tasks.add(task);
      todoRepository.saveTodoList(tasks);
    });
  }

  void onDelete(Todo todo) {
    deletedTask = todo;
    deletedTaskIndex = tasks.indexOf(todo);

    setState(() {
      tasks.remove(todo);
    });
    todoRepository.saveTodoList(tasks);

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
            todoRepository.saveTodoList(tasks);
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
                todoRepository.saveTodoList(tasks);
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
