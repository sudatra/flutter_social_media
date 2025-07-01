import 'package:flutter/material.dart';
import 'package:social_media_app/features/home/presentation/components/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Home"))
      ),
      drawer: CustomDrawer(),
    );
  }
}