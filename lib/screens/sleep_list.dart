import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_add.dart';

class SleepListScreen extends StatelessWidget {
  const SleepListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> list = ['6:23', '7:08', '5:24'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠時間一覧'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.bed,
                color: Colors.black,
              ),
              title: Text(
                list[index],
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return const SleepAddScreen();
              },
            ),
          );
        },
        child: const Icon(Icons.add_circle_sharp),
      ),
    );
  }
}
