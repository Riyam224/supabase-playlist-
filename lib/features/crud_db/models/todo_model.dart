// class Todo {
//   final int id;
//   final String title;
//   final bool isDone;
//   final DateTime? createdAt;

//   Todo({
//     required this.id,
//     required this.title,
//     required this.isDone,
//     this.createdAt,
//   });

//   factory Todo.fromJson(Map<String, dynamic> json) {
//     return Todo(
//       id: json['id'] as int,
//       title: json['title'] as String,
//       isDone: json['isDone'] as bool, // 👈 must match DB column
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'isDone': isDone,
//       'created_at': createdAt?.toIso8601String(),
//     };
//   }
// }
