// lib/models/todo_model.dart

import 'package:hive/hive.dart';
import '../constants/enums.dart';

part 'todo_model.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Unique typeId for the Todo model
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  final Priority priority;

  @HiveField(4)
  final Category category;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.priority,
    required this.category,
  });
}