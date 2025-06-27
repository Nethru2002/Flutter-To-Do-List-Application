// lib/widgets/add_edit_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/constants/enums.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:uuid/uuid.dart'; // Add uuid package: flutter pub add uuid

class AddEditTodoDialog extends ConsumerStatefulWidget {
  final Todo? todo; // If not null, we are in edit mode

  const AddEditTodoDialog({super.key, this.todo});

  @override
  ConsumerState<AddEditTodoDialog> createState() => _AddEditTodoDialogState();
}

class _AddEditTodoDialogState extends ConsumerState<AddEditTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  Priority _selectedPriority = Priority.medium;
  Category _selectedCategory = Category.personal;

  bool get isEditMode => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    if (isEditMode) {
      _selectedPriority = widget.todo!.priority;
      _selectedCategory = widget.todo!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final todoNotifier = ref.read(todoProvider.notifier);
      final newTodo = Todo(
        id: widget.todo?.id ?? const Uuid().v4(), // Use existing or generate new ID
        title: _titleController.text,
        priority: _selectedPriority,
        category: _selectedCategory,
        isDone: widget.todo?.isDone ?? false,
      );

      if (isEditMode) {
        todoNotifier.updateTodo(newTodo);
      } else {
        todoNotifier.addTodo(newTodo);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditMode ? 'Edit To-Do' : 'Add To-Do'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: Priority.values
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedPriority = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: Category.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEditMode ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}