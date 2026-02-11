import 'package:admin_pannel/presentation/home_dash/ui/home_page.dart';
//import 'package:admin_pannel/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vjcqccysqjupowbggzpa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZqY3FjY3lzcWp1cG93YmdnenBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAyNzY5MzAsImV4cCI6MjA4NTg1MjkzMH0.5LByLJkNhPjcH1q8tNk9f4ZhOtYnRcopTt-eYMyPp5w',
  );

  runApp(ProviderScope(child: ProviderScope(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase',
      // home: AdminLoginPage(),
      home: HomePage(),
    );
  }
}
