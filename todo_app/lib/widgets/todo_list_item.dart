// lib/widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/constants/enums.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/widgets/add_edit_dialog.dart';

class TodoListItem extends ConsumerWidget {
  final Todo todo;

  const TodoListItem({super.key, required this.todo});

  // Helper to get color based on priority
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red.shade300;
      case Priority.medium:
        return Colors.orange.shade300;
      case Priority.low:
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getPriorityColor(todo.priority);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AddEditTodoDialog(todo: todo),
          );
        },
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (value) {
            ref.read(todoProvider.notifier).toggleTodoStatus(todo);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          '${todo.category.name} - ${todo.priority.name}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}