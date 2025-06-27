// lib/providers/todo_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import '../services/hive_service.dart';

// The provider for our HiveService
final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

// The main provider that the UI will interact with.
// It uses AsyncNotifier to handle the initial async loading of todos from Hive.
final todoProvider = AsyncNotifierProvider<TodoNotifier, List<Todo>>(() {
  return TodoNotifier();
});

class TodoNotifier extends AsyncNotifier<List<Todo>> {
  // The build method is called when the provider is first read.
  // It's responsible for creating the initial state.
  @override
  Future<List<Todo>> build() async {
    // We get the HiveService instance and load the initial todos.
    final hiveService = ref.watch(hiveServiceProvider);
    return hiveService.getTodos();
  }

  // Method to add a new todo
  Future<void> addTodo(Todo todo) async {
    final hiveService = ref.read(hiveServiceProvider);
    // Update the state to loading
    state = const AsyncValue.loading();
    // Perform the async operation and update the state with the result
    state = await AsyncValue.guard(() async {
      await hiveService.addTodo(todo);
      return hiveService.getTodos(); // Re-fetch the list
    });
  }

  // Method to update an existing todo
  Future<void> updateTodo(Todo todo) async {
    final hiveService = ref.read(hiveServiceProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await hiveService.updateTodo(todo);
      return hiveService.getTodos();
    });
  }

  // Method to remove a todo
  Future<void> removeTodo(String id) async {
    final hiveService = ref.read(hiveServiceProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await hiveService.deleteTodo(id);
      return hiveService.getTodos();
    });
  }

  // Method to toggle the completion status
  Future<void> toggleTodoStatus(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      isDone: !todo.isDone, // Flip the status
      priority: todo.priority,
      category: todo.category,
    );
    await updateTodo(updatedTodo);
  }
}