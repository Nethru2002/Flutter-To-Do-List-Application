// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/widgets/add_edit_dialog.dart';
import 'package:todo_app/widgets/todo_list_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // A GlobalKey is needed for AnimatedList to work.
  final _listKey = GlobalKey<AnimatedListState>();
  
  @override
  Widget build(BuildContext context) {
    // Watch the provider to get the state of our to-do list.
    final todoState = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        // --- CHANGE IS HERE ---
        title: const Text('Nethru\'s To-Do'),
        // ----------------------
      ),
      body: todoState.when(
        // Show a loading spinner while data is being fetched
        loading: () => const Center(child: CircularProgressIndicator()),
        // Show an error message if something went wrong
        error: (err, stack) => Center(child: Text('Error: $err')),
        // When data is available, show the list
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('No to-dos yet. Add one!'));
          }
          return AnimatedList(
            key: _listKey,
            initialItemCount: todos.length,
            itemBuilder: (context, index, animation) {
              final todo = todos[index];
              return _buildItem(context, todo, animation);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddEditTodoDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  // A helper method to build list items with a slide animation
  Widget _buildItem(BuildContext context, todo, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Stack(
        children: [
          TodoListItem(todo: todo),
          // We add a Dismissible for the swipe-to-delete functionality
          Positioned.fill(
            child: Dismissible(
              key: ValueKey(todo.id), // Unique key for the Dismissible
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // Remove the item from the provider
                ref.read(todoProvider.notifier).removeTodo(todo.id);

                // We need to find the index of the item to remove it from AnimatedList
                final todoState = ref.read(todoProvider);
                final index = todoState.value!.indexWhere((t) => t.id == todo.id);

                if (index != -1) {
                  // This tells the AnimatedList to play the remove animation
                  _listKey.currentState?.removeItem(
                    index,
                    (context, animation) => _buildItem(context, todo, animation),
                  );
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title} deleted')),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: TodoListItem(todo: todo),
            ),
          )
        ],
      ),
    );
  }
}