import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PDFReorderScreen extends StatefulWidget {
  const PDFReorderScreen({super.key});

  @override
  State<PDFReorderScreen> createState() => _PDFReorderScreenState();
}

class _PDFReorderScreenState extends State<PDFReorderScreen> {
  String? _selectedFile;
  final List<int> _pageOrder = List.generate(8, (i) => i + 1); // Mock 8 pages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder Pages'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file, color: AppTheme.primaryGreen),
                title: Text(_selectedFile ?? 'Select PDF File'),
                subtitle: const Text('Tap to choose a file'),
                onTap: () {
                  setState(() => _selectedFile = 'document.pdf');
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('Drag to reorder pages:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _pageOrder.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _pageOrder.removeAt(oldIndex);
                    _pageOrder.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  return Card(
                    key: ValueKey(_pageOrder[index]),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${_pageOrder[index]}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkGreen),
                        ),
                      ),
                      title: Text('Page ${_pageOrder[index]}'),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectedFile != null ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New order: ${_pageOrder.join(', ')}')),
                );
                Navigator.pop(context);
              } : null,
              icon: const Icon(Icons.save),
              label: const Text('Save Order'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
