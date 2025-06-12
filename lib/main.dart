import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_riverpod/provider.dart';
import 'package:learn_riverpod/todo_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CounterApp(),
    );
  }
}

class CounterApp extends ConsumerWidget {
  const CounterApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int counterValue = ref.watch(counterNotifierProvider);
    return Scaffold(
      body: Text('counter value is $counterValue'),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              ref.read(counterNotifierProvider.notifier).increment();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              ref.read(counterNotifierProvider.notifier).decrement();
            },
            tooltip: 'Decrement',
            child: Icon(Icons.minimize_outlined),
          ),
        ],
      ),
    );
  }
}

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Add new todo'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      ref.read(todoProvider.notifier).addTodo(controller.text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) =>
                        ref.read(todoProvider.notifier).toggleTodo(todo.id),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, ref, todo);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            ref.read(todoProvider.notifier).deleteTodo(todo.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Todo todo) {
    final editController = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Todo"),
        content: TextField(controller: editController),
        actions: [
          TextButton(
            onPressed: () {
              final newText = editController.text.trim();
              if (newText.isNotEmpty) {
                ref.read(todoProvider.notifier).updateTodo(todo.id, newText);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
