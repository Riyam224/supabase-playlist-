import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:supabase_playlist/core/helper/supabase_helper.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> todos = [];
  bool isLoading = false;

  // todo read all todos

  Future readAllTodos() async {
    setState(() => isLoading = true);
    try {
      final result = await SupabaseHelper.client
          .from('todos')
          .select()
          .order('created_at', ascending: true);

      log('Fetched result: $result'); // Debug print to check

      setState(() {
        todos = (result as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching todos: $e');
      setState(() => isLoading = false);
    }
  }

  // todo  insert todo
  Future insertTodo() async {
    try {
      await SupabaseHelper.client.from('todos').insert({
        'title': _controller.text,
        'isDone': false,
      });

      await readAllTodos(); // refresh list
    } catch (e) {
      log('Error inserting todo: $e');
    }
    _controller.clear();
  }

  // todo update todo

  Future updateTodo(int id, String title, bool isDone) async {
    try {
      await SupabaseHelper.client
          .from('todos')
          .update({'title': title, 'isDone': isDone})
          .eq('id', id);

      await readAllTodos(); // refresh list
    } catch (e) {
      log('Error updating todo: $e');
    }
  }

  Future deleteTodo(int id) async {
    try {
      await SupabaseHelper.client.from('todos').delete().eq('id', id);
      await readAllTodos(); // refresh list
    } catch (e) {
      log('Error deleting todo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    readAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos Screen"), centerTitle: true),
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
                // todo insert todo
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
                            // todo
                            leading: Checkbox(
                              value: todo['isDone'],
                              onChanged: (value) {
                                setState(() {
                                  updateTodo(
                                    todo['id'],
                                    todo['title'],
                                    value ?? false,
                                  );
                                });
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
                              onPressed: () {
                                deleteTodo(todo['id']);
                              },
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
