import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';

enum AppBarType { mainScreen, other }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarType appBarType;

  const CustomAppBar({super.key, this.appBarType = AppBarType.mainScreen});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Image.asset(
        'assets/aoy.png',
        width: 60,
        height: 60,
      ),
      leading: appBarType == AppBarType.mainScreen
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
