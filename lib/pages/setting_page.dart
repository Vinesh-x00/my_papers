import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            children: [
            ],
          ),
        ));
  }
}
