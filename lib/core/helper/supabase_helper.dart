import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_playlist/core/utils/constants.dart';

abstract class SupabaseHelper {
  static const String projectUrl = SUPABASE_URL;
  static const String anonKey = SUPABASE_ANON_KEY;

  static Future init() async {
    await Supabase.initialize(url: projectUrl, anonKey: anonKey);
  }

  // todo
  static SupabaseClient get client => Supabase.instance.client;
}
