import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/file_manager_provider.dart';
import '../../../injection_container.dart' as di;

class FileManagerScreen extends StatelessWidget {
  const FileManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<FileManagerProvider>()..loadFiles(),
      child: const _FileManagerContent(),
    );
  }
}

class _FileManagerContent extends StatelessWidget {
  const _FileManagerContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FileManagerProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Files")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.documents.length,
              itemBuilder: (context, index) {
                final doc = provider.documents[index];
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(doc.name),
                  subtitle: Text(doc.createdAt.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => provider.deleteFile(doc.id),
                  ),
                  onTap: () {
                    // Open viewer
                  },
                );
              },
            ),
    );
  }
}
