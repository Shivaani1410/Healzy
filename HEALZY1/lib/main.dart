import 'package:flutter/material.dart';
import 'package:healzy/pages/beg_ques.dart';
import 'package:healzy/pages/beg_ques2.dart';
import 'package:healzy/pages/login.dart';
import 'package:healzy/pages/splash_screen.dart'; // Update with your actual package name
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your project credentials
  await Supabase.initialize(
    url: 'https://woyreygjdgmozqcjnmcv.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndveXJleWdqZGdtb3pxY2pubWN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ0Nzg5NzgsImV4cCI6MjA2MDA1NDk3OH0.SwY_8wvQ4C0IN7L_grFLxpKnxqSUKwhdw1JJtcsVZ_o', // Replace with your Supabase anon key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Assessment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Petemos',
      ),
      home: HealzySplashScreen(nextScreen: LoginScreen()), // Directly load the SelfAssessmentPage
      debugShowCheckedModeBanner: false,
    );
  }
}