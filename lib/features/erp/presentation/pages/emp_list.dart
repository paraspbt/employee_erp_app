import 'package:flutter/material.dart';

class EmpListPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EmpListPage());
  const EmpListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('success')),
    );
  }
}
