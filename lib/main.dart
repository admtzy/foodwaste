import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rgccrhhbdpbyysasfohh.supabase.co',
    anonKey: 'sb_publishable_kzhptaucDScrEC6dMv4NZQ_tcy9MBxz',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Food Expiry',

      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      home: const HomePage(),
    );
  }
}