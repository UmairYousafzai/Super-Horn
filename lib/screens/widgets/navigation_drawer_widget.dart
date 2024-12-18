import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superhorn/screens/auth/login_screen.dart';
import 'package:superhorn/utils/navigations.dart';

import '../../providers/shared_pref_provider.dart';

class MyDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the shared preferences provider to get user data
    final sharedPreferencesNotifier = ref.read(sharedPreferencesProvider);

    // Retrieve user data from SharedPreferences using the getUserData function
    final userData = sharedPreferencesNotifier.getUserData();

    return Drawer(
      child: Column(
        children: [
          // Drawer Header with User Info
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.red.shade400),
            accountName: Text(userData['name'] ?? 'No Name'),
            accountEmail: Text(userData['email'] ?? 'No Email'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          // Drawer Options
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help"),
            onTap: () {},
          ),
          const Divider(),
          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await sharedPreferencesNotifier.clearUserData();
              navigatePushAndRemoveUntil(context, const LoginScreen(), false);
            },
          ),
        ],
      ),
    );
  }
}
