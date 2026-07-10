import 'package:flutter/material.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Title'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Nội dung màn hình mới',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
