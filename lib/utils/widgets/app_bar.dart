import 'package:flutter/material.dart';

enum AppBarType { mainScreen, other }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarType appBarType;

  const CustomAppBar({super.key, this.appBarType = AppBarType.mainScreen});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0x74CFCCCC),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
