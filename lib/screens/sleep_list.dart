import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_add.dart';
import 'package:sleep_management_app/widgets/logout_button.dart';
import 'package:sleep_management_app/widgets/sleep_list_item.dart';

class SleepListScreen extends StatefulWidget {
  const SleepListScreen({super.key});

  @override
  State<SleepListScreen> createState() => _SleepListScreenState();
}

class _SleepListScreenState extends State<SleepListScreen> {
  @override
  Widget build(BuildContext context) {
    // ユーザーのUIDを取得
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    // ユーザごとにデータを保存しているパス
    String userPath = 'users/$userUid/data';

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          // ユーザーごとのパスに変更する
          .collection(userPath)
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${FirebaseAuth.instance.currentUser!.email}'),
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
              title: Text('${FirebaseAuth.instance.currentUser!.email}'),
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
              title: Text('${FirebaseAuth.instance.currentUser!.email}'),
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
            title: Text('${FirebaseAuth.instance.currentUser!.email}'),
            actions: const [
              LogoutButton(),
            ],
          ),
          body: ListView.builder(
            itemCount: loadedData.length,
            itemBuilder: (context, index) {
              final item = loadedData[index].data();
              final documentId = loadedData[index].id;
              return SleepListItem(
                itemData: item,
                documentId: documentId,
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
