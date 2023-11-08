import 'package:flutter/material.dart';

class SleepListItem extends StatelessWidget {
  const SleepListItem({super.key, required this.itemData});

  final Map<String, dynamic> itemData;

  @override
  Widget build(BuildContext context) {
    final total = itemData['total'];
    final sleep = itemData['sleep'];
    final core = itemData['core'];

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
  }
}
