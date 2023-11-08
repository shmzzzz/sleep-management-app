import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_add.dart';
import 'package:sleep_management_app/widgets/logout_button.dart';

class SleepListScreen extends StatefulWidget {
  const SleepListScreen({super.key});

  @override
  State<SleepListScreen> createState() => _SleepListScreenState();
}

class _SleepListScreenState extends State<SleepListScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sleep-data')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('睡眠時間一覧'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              actions: const [
                LogoutButton(),
              ],
            ),
            body: const Center(
              child: CircularProgressIndicator(),
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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('睡眠時間一覧'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              actions: const [
                LogoutButton(),
              ],
            ),
            body: const Center(
              child: Text('データがありません。'),
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

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('睡眠時間一覧'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              actions: const [
                LogoutButton(),
              ],
            ),
            body: const Center(
              child: Text('エラーが発生しました。'),
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

        final loadedData = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            title: const Text('睡眠時間一覧'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            actions: const [
              LogoutButton(),
            ],
          ),
          body: ListView.builder(
            itemCount: loadedData.length,
            itemBuilder: (context, index) {
              final item = loadedData[index].data();
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
      },
    );
  }
}
