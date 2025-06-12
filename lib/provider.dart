import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_riverpod/todo_model.dart';
import 'package:uuid/uuid.dart';

/* 
🧠 1. Provider — Read-Only, Static or Derived Data
      Provider is used to expose immutable or derived data. It doesn’t hold or manage state that changes over time.
      ✅ Use Provider when:
            You want to read-only data.

          You want to compute derived values from other providers.

          You don’t need to modify state directly from the UI.
*/

final Provider<String> greetingProvider = Provider<String>(
  (ref) => 'Hello, World!',
);

/* 
🔁 2. StateProvider — Simple Mutable State
StateProvider is for simple, mutable values like counters, booleans, etc.

✅ Use StateProvider when:
You need a single value that can change (like an int, bool, or String).

You want quick access and easy updates via .state.
*/

/* 
⚙️ 3. StateNotifier — Advanced, Structured State + Logic
StateNotifier is a class-based way to manage complex or structured state with full business logic control.

✅ Use StateNotifier when:
You have a list, map, object, or model that requires multiple operations (CRUD).

You want encapsulation of logic (e.g., add(), remove(), toggle()).

Your state has relationships or side effects (e.g., API calls, validation, etc.).
*/

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

final counterNotifierProvider = StateNotifierProvider<CounterNotifier, int>((
  ref,
) {
  return CounterNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);
  void addTodo(String title) {
    final newTodo = Todo(id: Uuid().v4(), title: title);
    state = [...state, newTodo];
  }

  void toggleTodo(String id) {
    state = state.map((todo) {
      return todo.id == id ? todo.copyWith(isDone: !todo.isDone) : todo;
    }).toList();
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void updateTodo(String id, String newTitle) {
    state = state.map((todo) {
      return todo.id == id ? todo.copyWith(title: newTitle) : todo;
    }).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
