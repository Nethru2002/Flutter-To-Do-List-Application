// lib/services/hive_service.dart

import 'package:hive/hive.dart';
import '../models/todo_model.dart';

class HiveService {
  final String _boxName = 'todoBox';

  // Get all todos from the box
  Future<List<Todo>> getTodos() async {
    final box = await Hive.openBox<Todo>(_boxName);
    // Return a new list to avoid issues with unmodifiable lists
    return box.values.toList();
  }

  // Add a new todo to the box
  Future<void> addTodo(Todo todo) async {
    final box = await Hive.openBox<Todo>(_boxName);
    // Hive uses the object's 'key' to store it. We use our own 'id' as the key.
    await box.put(todo.id, todo);
  }

  // Update an existing todo
  Future<void> updateTodo(Todo todo) async {
    // 'put' in Hive either adds a new item or updates an existing one if the key is the same.
    await addTodo(todo); 
  }

  // Delete a todo from the box
  Future<void> deleteTodo(String id) async {
    final box = await Hive.openBox<Todo>(_boxName);
    await box.delete(id);
  }
}