import 'package:flutter/material.dart';
import 'package:sleep_management_app/widgets/logout_button.dart';

class AppBarComponentWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarComponentWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: const [
        LogoutButton(),
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size(double.infinity, 60.0);
  }
}
