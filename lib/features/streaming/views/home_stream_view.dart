import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_playlist/core/helper/supabase_helper.dart';

class TodoScreenStream extends StatefulWidget {
  const TodoScreenStream({super.key});

  @override
  State<TodoScreenStream> createState() => _TodoScreenStreamState();
}

class _TodoScreenStreamState extends State<TodoScreenStream> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> todos = [];
  bool isLoading = false;
  StreamSubscription? _todoSubscription;

  // ✅ Stream todos
  Future<void> startTodoStream() async {
    setState(() => isLoading = true);

    _todoSubscription = SupabaseHelper.client
        .from('todos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .listen((event) {
          log("Stream event: $event");

          setState(() {
            todos = List<Map<String, dynamic>>.from(event);
            isLoading = false;
          });
        });
  }

  // ✅ Insert todo
  Future<void> insertTodo() async {
    try {
      if (_controller.text.trim().isEmpty) return;

      await SupabaseHelper.client.from('todos').insert({
        'title': _controller.text.trim(),
        'isDone': false,
      });
      await startTodoStream(); // Refresh the stream
    } catch (e) {
      log("Error inserting todo: $e");
    }
    _controller.clear();
  }

  // ✅ Update todo
  Future<void> updateTodo(int id, String title, bool isDone) async {
    try {
      await SupabaseHelper.client
          .from('todos')
          .update({'title': title, 'isDone': isDone})
          .eq('id', id);
      await startTodoStream(); // Refresh the stream
    } catch (e) {
      log("Error updating todo: $e");
    }
  }

  // ✅ Delete todo
  Future<void> deleteTodo(int id) async {
    try {
      await SupabaseHelper.client.from('todos').delete().eq('id', id);
      await startTodoStream(); // Refresh the stream
    } catch (e) {
      log("Error deleting todo: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    startTodoStream();
  }

  @override
  void dispose() {
    _todoSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos Stream"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Input + Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter todo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: insertTodo, child: const Text("Add")),
              ],
            ),
            const SizedBox(height: 20),

            /// Todo list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: todo['isDone'],
                              onChanged: (value) {
                                updateTodo(
                                  todo['id'],
                                  todo['title'],
                                  value ?? false,
                                );
                              },
                            ),
                            title: Text(
                              todo['title'],
                              style: TextStyle(
                                decoration: todo['isDone']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTodo(todo['id']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
