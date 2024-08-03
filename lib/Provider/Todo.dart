import 'package:flutter/material.dart';
import 'package:todo_list_provider/Model/Todo.dart';
import 'package:uuid/uuid.dart';

import 'todo.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  final Uuid _uuid = Uuid();

  List<Todo> get todos => _todos;

  void addTodo(String title) {
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title,
    );
    _todos.add(newTodo);
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      notifyListeners();
    }
  }

  void updateTodo(String id, String newTitle) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].title = newTitle;
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
