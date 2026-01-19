import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as auth_prov;
import 'package:url_launcher/url_launcher_string.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          Consumer<auth_prov.AuthProvider>(
            builder: (context, auth, _) {
              final user = auth.user;
              return Column(
                children: [
                   UserAccountsDrawerHeader(
                    accountName: Text(user?.displayName ?? 'Not Signed In'),
                    accountEmail: user?.email != null ? Text(user!.email!) : null,
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                      child: user?.photoUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
                    ),
                    decoration: const BoxDecoration(color: Color(0xFF00C853)),
                  ),
                  if (user == null) ...[
                    ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Sign In With Google'),
                      onTap: () => auth.signInWithGoogle(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.developer_mode),
                      title: const Text('Demo Login'),
                      onTap: () => auth.signInDemo(),
                    ),
                  ] else
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      onTap: () => auth.signOut(),
                    ),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () async {
              const url =
                  'https://example.com/privacy'; // Replace with real URL
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              }
            },
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About App'),
            subtitle: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
