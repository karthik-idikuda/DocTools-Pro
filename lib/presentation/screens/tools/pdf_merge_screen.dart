import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pdf_tools_provider.dart';
import '../../../injection_container.dart' as di;

class PDFMergeScreen extends StatelessWidget {
  const PDFMergeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PDFToolsProvider>(
      create: (_) => di.sl<PDFToolsProvider>(),
      child: const _MergeContent(),
    );
  }
}

class _MergeContent extends StatelessWidget {
  const _MergeContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PDFToolsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge PDFs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: provider.pickFiles,
          )
        ],
      ),
      body: provider.isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (provider.error != null)
                  Container(
                    color: Colors.red.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(provider.error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                Expanded(
                  child: provider.selectedFiles.isEmpty
                      ? const Center(child: Text('Add PDFs to merge'))
                      : ReorderableListView.builder(
                          itemCount: provider.selectedFiles.length,
                          onReorder: (oldIndex, newIndex) {
                            // Simple reorder logic if we exposed a reorder method in provider
                            // For now basic display
                          },
                          itemBuilder: (context, index) {
                            final file = provider.selectedFiles[index];
                            return ListTile(
                              key:
                                  ValueKey(file.path), // Use path as unique key
                              leading: const Icon(Icons.picture_as_pdf),
                              title: Text(file.path.split('/').last),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => provider.removeFile(index),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: provider.selectedFiles.length < 2
                        ? null
                        : () async {
                            final success = await provider.mergeSelectedFiles();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("PDFs Merged Successfully")));
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Merge PDFs'),
                  ),
                ),
              ],
            ),
    );
  }
}
