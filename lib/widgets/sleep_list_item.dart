import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_management_app/screens/sleep_edit.dart';

class SleepListItem extends StatefulWidget {
  const SleepListItem({
    super.key,
    required this.itemData,
    required this.documentId,
  });

  final Map<String, dynamic> itemData;
  final String documentId;

  @override
  State<SleepListItem> createState() => _SleepListItemState();
}

class _SleepListItemState extends State<SleepListItem> {
  bool isAchieved = false;

  void setInitialAchievement() {
    DateTime totalDateTime =
        DateFormat('HH:mm').parse(widget.itemData['total']);
    DateTime goalDateTime = DateFormat('HH:mm').parse(widget.itemData['goal']);
    // 目標との比較
    // アイコンを更新したいのでsetState内で比較する
    setState(() {
      isAchieved = totalDateTime.isAfter(goalDateTime) ||
          totalDateTime.isAtSameMomentAs(goalDateTime);
    });
  }

  void updateAchievement(bool updatedAchievement) {
    setState(() {
      isAchieved = updatedAchievement;
    });
  }

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
      // Firebaseからデータを削除
      await FirebaseFirestore.instance
          .collection(userPath)
          .doc(documentId)
          .delete();
    } catch (error) {
      showSnackBar(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setInitialAchievement();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.itemData['total'];
    final sleep = widget.itemData['sleep'];
    final core = widget.itemData['core'];
    final isAchieved = widget.itemData['isAchieved'];

    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () async {
          var result = await Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return SleepEditScreen(
                  initialData: widget.itemData,
                  documentId: widget.documentId,
                );
              },
            ),
          );

          // データが更新された場合はisAchievedが変わる可能性がある
          if (result != null) {
            updateAchievement(result);
          }
        },
        leading: isAchieved
            ? const Icon(Icons.check_circle_outline_outlined)
            : const Icon(Icons.bed),
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
            deleteData(widget.documentId);
          },
        ),
      ),
    );
  }
}
