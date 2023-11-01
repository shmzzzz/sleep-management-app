import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_add.dart';

class SleepListScreen extends StatefulWidget {
  const SleepListScreen({super.key});

  @override
  State<SleepListScreen> createState() => _SleepListScreenState();
}

class _SleepListScreenState extends State<SleepListScreen> {
  List<String> list = [];

  @override
  Widget build(BuildContext context) {
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
        onPressed: () async {
          final result = await Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return const SleepAddScreen();
              },
            ),
          );

          if (result != null) {
            // 入力値を取得し、リストに追加
            final inputData = result;
            final total = inputData['total'];
            final sleep = inputData['sleep'];
            final core = inputData['core'];

            // 定義していたリストに追加する
            setState(() {
              list.add(total!);
            });
          }
        },
        child: const Icon(Icons.add_circle_sharp),
      ),
    );
  }
}
