import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_form_dialog.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];

  // CREATE
  void _addTodo() async {
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const TodoFormDialog(),
    );

    if (title != null) {
      setState(() {
        _todos.add(Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
        ));
      });
    }
  }

  // UPDATE
  void _editTodo(Todo todo) async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) => TodoFormDialog(todo: todo),
    );

    if (newTitle != null) {
      setState(() {
        todo.title = newTitle;
      });
    }
  }

  // UPDATE (toggle completion)
  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  // DELETE
  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${todo.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _todos.add(todo);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'No todos yet!\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return TodoItem(
                  todo: todo,
                  onToggle: () => _toggleTodo(todo),
                  onEdit: () => _editTodo(todo),
                  onDelete: () => _deleteTodo(todo),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
