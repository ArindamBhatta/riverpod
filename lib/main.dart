import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

//global scope
final Provider<String> greetingProvider = Provider<String>(
  (ref) => 'Hello, World!',
);
//Use StateProvider instead of Provider when you want mutable state:   final counterProvider = StateProvider<int>((ref) => 0);
final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterValue = ref.watch(counterProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('count value is $counterValue'),
          SizedBox(height: 8),
          Consumer(
            builder: (context, ref, child) {
              final String greeting = ref.read(greetingProvider);
              return Text(greeting);
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              ref.read(counterProvider.notifier).state++;
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          Spacer(),
          FloatingActionButton(
            onPressed: () {
              ref.read(counterProvider.notifier).state--;
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.minimize),
          ),
        ],
      ),
    );
  }
}
