import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_edit.dart';
import 'package:sleep_management_app/services/sleep_repository.dart';
import 'package:sleep_management_app/utils/context_extensions.dart';

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

  void updateAchievement(bool updatedAchievement) {
    setState(() {
      isAchieved = updatedAchievement;
    });
  }

  void deleteData(String documentId) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      const repo = SleepRepository();
      await repo.delete(userUid, documentId);
    } catch (error) {
      context.showSnackBar(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // 初期表示は保存済みの値に合わせる
    isAchieved = widget.itemData['isAchieved'] == true;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.itemData['total'];
    final sleep = widget.itemData['sleep'];
    final core = widget.itemData['core'];
    // isAchieved は state を使用

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

          // 更新後に戻ってきた場合、必要ならローカル表示を更新
          if (result is bool) updateAchievement(result as bool);
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
