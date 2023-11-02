import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sleep_management_app/screens/sleep_add.dart';

class SleepListScreen extends StatefulWidget {
  const SleepListScreen({super.key});

  @override
  State<SleepListScreen> createState() => _SleepListScreenState();
}

class _SleepListScreenState extends State<SleepListScreen> {
  List<Map<String, String>> list = [];

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
          final item = list[index];
          final total = item['total'];
          final sleep = item['sleep'];
          final core = item['core'];

          return Card(
            elevation: 5,
            child: ListTile(
              leading: const Icon(
                Icons.bed,
                color: Colors.black,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Sleep',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Core',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            ':',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            ':',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            ':',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$total',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '$sleep',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '$core',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
            // 定義していたリストに追加する
            final inputData = result as Map<String, String>;
            setState(() {
              list.add(inputData);
            });
          }
        },
        child: const Icon(Icons.add_circle_sharp),
      ),
    );
  }
}
