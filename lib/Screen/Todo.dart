import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/Provider/Todo.dart';


class TodoListScreen extends StatelessWidget {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (value) {
                    todoProvider.toggleTodoStatus(todo.id);
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editTodoDialog(context, todoProvider, todo.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        todoProvider.deleteTodo(todo.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add To-Do'),
          content: TextField(
            controller: _todoController,
            decoration: InputDecoration(hintText: 'Enter a new task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  Provider.of<TodoProvider>(context, listen: false)
                      .addTodo(_todoController.text);
                  _todoController.clear();
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editTodoDialog(BuildContext context, TodoProvider todoProvider, String id) {
    final todo = todoProvider.todos.firstWhere((element) => element.id == id);
    _todoController.text = todo.title;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit To-Do'),
          content: TextField(
            controller: _todoController,
            decoration: InputDecoration(hintText: 'Edit the task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  todoProvider.updateTodo(id, _todoController.text);
                  _todoController.clear();
                }
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
