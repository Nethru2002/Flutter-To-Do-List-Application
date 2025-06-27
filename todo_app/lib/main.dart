// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/constants/enums.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/home_screen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for Flutter
  await Hive.initFlutter();
  
  // Register the generated adapters
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // The ProviderScope is what makes Riverpod work.
  // It stores the state of all our providers.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // --- CHANGE IS HERE ---
      title: 'Nethru\'s To-Do', 
      // ----------------------
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade100,
          foregroundColor: Colors.deepPurple.shade900,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}