import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const supabaseUrl = 'https://ivvzevqtgfxuifclnjgn.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2dnpldnF0Z2Z4dWlmY2xuamduIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NzcwMzksImV4cCI6MjA3MjQ1MzAzOX0.bR2C31eJVFlmCET_Kao8et3TK4BOM7pR5vvpLGhG98s';

  static Future<void> init() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
