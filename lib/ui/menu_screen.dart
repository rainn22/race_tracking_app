import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/user_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/ui/widgets/role_card.dart';
import 'package:race_tracking_app/models/user.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentRole = userProvider.getCurrentRole();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Role.values.map((role) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.gap),
              child: RoleCard(
                role: role,
                isSelected: currentRole == role,
                onTap: () {
                  userProvider.switchRole(role);
                  if (role == Role.manager) {
                    Navigator.pushNamed(context, '/participant');
                  } else if (role == Role.tracker) {
                    Navigator.pushNamed(context, '/tracker');
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
