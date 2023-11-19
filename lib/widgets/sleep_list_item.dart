import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_edit.dart';

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
        // ユーザーのUIDを取得
        String userUid = FirebaseAuth.instance.currentUser!.uid;
        // ユーザーごとにデータを保存するパスを構築
        String userPath = 'users/$userUid/data';
        await FirebaseFirestore.instance
            .collection(userPath)
            .doc(documentId)
            .delete();
      } catch (error) {
        showSnackBar(error.toString());
      }
    }

    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return SleepEditScreen(
                  initialData: itemData,
                  documentId: documentId,
                );
              },
            ),
          );
        },
        leading: const Icon(Icons.bed),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Total'),
                    Text('Sleep'),
                    Text('Core'),
                  ],
                ),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(':'),
                    Text(':'),
                    Text(':'),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$total'),
                    Text('$sleep'),
                    Text('$core'),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            deleteData(documentId);
          },
        ),
      ),
    );
  }
}
