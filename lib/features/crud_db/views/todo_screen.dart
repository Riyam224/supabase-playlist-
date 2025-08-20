// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:supabase_playlist/core/helper/supabase_helper.dart';
// import 'package:supabase_playlist/features/crud_db/models/todo_model.dart';

// class TodoScreen extends StatefulWidget {
//   const TodoScreen({super.key});

//   @override
//   State<TodoScreen> createState() => _TodoScreenState();
// }

// class _TodoScreenState extends State<TodoScreen> {
//   final TextEditingController _controller = TextEditingController();
//   List<Todo> _todos = [];
//   bool isLoading = false;

//   /// ✅ Fetch all todos
//   Future<void> readAllTodos() async {
//     setState(() => isLoading = true);
//     try {
//       final result = await SupabaseHelper.client
//           .from('todos')
//           .select()
//           .order('id', ascending: true);

//       _todos = (result as List)
//           .map((item) => Todo.fromJson(item as Map<String, dynamic>))
//           .toList();

//       log('Todos fetched: ${_todos.length}');
//     } catch (e) {
//       log('Error fetching todos: $e');
//     }
//     setState(() => isLoading = false);
//   }

//   /// ✅ Insert new todo
//   Future<void> insertTodo() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     try {
//       final response = await SupabaseHelper.client.from('todos').insert({
//         'title': text,
//         'isDone': false, // ✅ matches your DB column
//       }).select();

//       readAllTodos();

//       if (response.isNotEmpty) {
//         final newTodo = Todo.fromJson(response.first);
//         setState(() {
//           _todos.add(newTodo);
//         });
//       }
//     } catch (e) {
//       log('Error creating todo: $e');
//     }

//     _controller.clear();
//   }

//   /// ✅ Update todo (toggle done)
//   // Future<void> updateTodoStatus(Todo todo) async {
//   //   try {
//   //     await SupabaseHelper.client
//   //         .from('todos')
//   //         .update({'is_done': !todo.isDone})
//   //         .eq('id', todo!.id.);

//   //     await readAllTodos();
//   //   } catch (e) {
//   //     log('Error updating todo: $e');
//   //   }
//   // }

//   /// ✅ Delete todo
//   // Future<void> deleteTodo(int id) async {
//   //   try {
//   //     await SupabaseHelper.client.from('todos').delete().eq('id', id);
//   //     await readAllTodos();
//   //     log('Todo deleted: $id');
//   //   } catch (e) {
//   //     log('Error deleting todo: $e');
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     readAllTodos();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Todos Screen"), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// Input + Add button
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Enter todo",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(onPressed: insertTodo, child: const Text("Add")),
//               ],
//             ),
//             const SizedBox(height: 20),

//             /// Todo list
//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: _todos.length,
//                       itemBuilder: (context, index) {
//                         final todo = _todos[index];
//                         return Card(
//                           child: ListTile(
//                             leading: Checkbox(
//                               value: todo.isDone,
//                               onChanged: (_) => {},
//                             ),
//                             title: Text(
//                               todo.title,
//                               style: TextStyle(
//                                 decoration: todo.isDone
//                                     ? TextDecoration.lineThrough
//                                     : TextDecoration.none,
//                               ),
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => {},
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
