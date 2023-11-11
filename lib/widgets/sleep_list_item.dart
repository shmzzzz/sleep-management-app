import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SleepListItem extends StatelessWidget {
  const SleepListItem({
    super.key,
    required this.itemData,
    required this.documentId,
  });

  final Map<String, dynamic> itemData;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    final total = itemData['total'];
    final sleep = itemData['sleep'];
    final core = itemData['core'];

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    void deleteData(String documentId) async {
      try {
        await FirebaseFirestore.instance
            .collection('sleep-data')
            .doc(documentId)
            .delete();
      } catch (error) {
        showSnackBar(error.toString());
      }
    }

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
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
          onPressed: () {
            deleteData(documentId);
          },
        ),
      ),
    );
  }
}
