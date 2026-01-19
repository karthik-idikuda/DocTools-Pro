import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _autoSave = true;
  String _compressionQuality = 'Balanced';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
            activeTrackColor: AppTheme.primaryGreen,
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          const _SectionHeader(title: 'Document Settings'),
          SwitchListTile(
            title: const Text('Auto-Save'),
            subtitle: const Text('Automatically save changes'),
            value: _autoSave,
            onChanged: (val) => setState(() => _autoSave = val),
            activeTrackColor: AppTheme.primaryGreen,
            secondary: const Icon(Icons.save),
          ),
          ListTile(
            leading: const Icon(Icons.compress),
            title: const Text('Compression Quality'),
            subtitle: Text(_compressionQuality),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCompressionDialog(),
          ),
          const Divider(),
          const _SectionHeader(title: 'Storage'),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Clear Cache'),
            subtitle: const Text('Free up storage space'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Empty Trash'),
            subtitle: const Text('Permanently delete trashed files'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trash emptied!')),
              );
            },
          ),
          const Divider(),
          const _SectionHeader(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showCompressionDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Compression Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Low', 'Balanced', 'High'].map((option) {
            final isSelected = _compressionQuality == option;
            return ListTile(
              title: Text(option),
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? AppTheme.primaryGreen : Colors.grey,
              ),
              onTap: () {
                setState(() => _compressionQuality = option);
                Navigator.pop(dialogContext);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
