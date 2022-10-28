import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.task,
    required this.onDelete,
  });

  final Todo task;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: 'Deletar',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              foregroundColor: Colors.white,
              onPressed: (BuildContext context) {
                onDelete(task);
              },
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MMM/yyyy - hh:mm').format(task.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
