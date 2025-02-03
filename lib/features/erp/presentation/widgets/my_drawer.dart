import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/features/auth/presentation/AuthBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget myDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: AppPallete.backgroundColor,
    child: Column(
      children: [
        SizedBox(
          height: 120,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: AppPallete.dullGreen,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: AppPallete.backgroundColor,
                ),
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout'),
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Dispatch logout event
              context.read<AuthBloc>().add(AuthLogoutEvent());

              // Close the dialog
              Navigator.pop(context);

              // Close the drawer
              Navigator.pop(context);
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
