import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PDFDeletePagesScreen extends StatefulWidget {
  const PDFDeletePagesScreen({super.key});

  @override
  State<PDFDeletePagesScreen> createState() => _PDFDeletePagesScreenState();
}

class _PDFDeletePagesScreenState extends State<PDFDeletePagesScreen> {
  String? _selectedFile;
  final Set<int> _selectedPages = {};
  final int _totalPages = 10; // Mock

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Pages'),
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
            const Text('Select pages to delete:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  final pageNum = index + 1;
                  final isSelected = _selectedPages.contains(pageNum);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedPages.remove(pageNum);
                        } else {
                          _selectedPages.add(pageNum);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.red.shade700 : Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$pageNum',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectedFile != null && _selectedPages.isNotEmpty ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted pages: ${_selectedPages.toList()}')),
                );
                Navigator.pop(context);
              } : null,
              icon: const Icon(Icons.delete),
              label: Text('Delete ${_selectedPages.length} Page(s)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
