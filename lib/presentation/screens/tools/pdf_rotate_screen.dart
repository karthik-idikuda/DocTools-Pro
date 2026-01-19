import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PDFRotateScreen extends StatefulWidget {
  const PDFRotateScreen({super.key});

  @override
  State<PDFRotateScreen> createState() => _PDFRotateScreenState();
}

class _PDFRotateScreenState extends State<PDFRotateScreen> {
  String? _selectedFile;
  int _rotationAngle = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotate PDF'),
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
            const Text('Rotation Angle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [90, 180, 270].map((angle) {
                final isSelected = _rotationAngle == angle;
                return ChoiceChip(
                  label: Text('$angle°'),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryGreen,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  onSelected: (_) => setState(() => _rotationAngle = angle),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _selectedFile != null ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rotation applied!')),
                );
                Navigator.pop(context);
              } : null,
              icon: const Icon(Icons.rotate_right),
              label: const Text('Rotate PDF'),
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
