import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_management_app/screens/sleep_add.dart';
import 'package:sleep_management_app/widgets/appbar_component_widget.dart';
import 'package:sleep_management_app/widgets/drawer_list.dart';
import 'package:sleep_management_app/widgets/sleep_list_item.dart';
import 'package:sleep_management_app/services/sleep_repository.dart';

class SleepListScreen extends StatefulWidget {
  const SleepListScreen({super.key});

  @override
  State<SleepListScreen> createState() => _SleepListScreenState();
}

class _SleepListScreenState extends State<SleepListScreen> {
  void _goToAdd() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const SleepAddScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    const repo = SleepRepository();

    return StreamBuilder(
      stream: repo.stream(userUid),
      builder: (context, snapshot) {
        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = const Center(child: Text('エラーが発生しました。'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          body = const Center(child: Text('データがありません。'));
        } else {
          final loadedData = snapshot.data!.docs;
          body = ListView.builder(
            itemCount: loadedData.length,
            itemBuilder: (context, index) {
              final item = loadedData[index].data();
              final documentId = loadedData[index].id;
              return SleepListItem(
                itemData: item,
                documentId: documentId,
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBarComponentWidget(
            title: FirebaseAuth.instance.currentUser!.email!,
          ),
          drawer: const DrawerList(),
          body: body,
          floatingActionButton: FloatingActionButton(
            onPressed: _goToAdd,
            child: const Icon(Icons.add_circle_sharp),
          ),
        );
      },
    );
  }
}
