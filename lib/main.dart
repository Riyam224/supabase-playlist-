import 'package:flutter/material.dart';
import 'package:supabase_playlist/core/helper/supabase_helper.dart';
import 'package:supabase_playlist/features/storage_bucket/views/storage_example_view.dart';
import 'package:supabase_playlist/features/streaming/views/home_stream_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const TodoScreenStream(),
    );
  }
}
